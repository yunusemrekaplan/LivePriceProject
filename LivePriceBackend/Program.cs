using System.Text;
using LivePriceBackend.Data;
using LivePriceBackend.Filters;
using LivePriceBackend.Middlewares;
using LivePriceBackend.Services;
using LivePriceBackend.Services.BackgroundServices;
using LivePriceBackend.Services.Hubs;
using LivePriceBackend.Services.JwtFactory;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Microsoft.Extensions.Options;
using LivePriceBackend.Services.ParityServices;
using Polly;
using Microsoft.Extensions.Caching.Memory;
using LivePriceBackend.Services.Caching;
using Microsoft.AspNetCore.RateLimiting;

var builder = WebApplication.CreateBuilder(args);

// Loglama yapılandırması
builder.Logging.ClearProviders();
builder.Logging.AddConsole();
builder.Logging.AddDebug();

// Veritabanı bağlantısını ekleyelim
builder.Services.AddDbContext<LivePriceDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"), b => b.MigrationsAssembly("LivePriceBackend")));

// Register IUserService
builder.Services.AddHttpContextAccessor();

// Add singleton services
builder.Services.AddSingleton<ConnectionTracker>();

// Add Caching Services
builder.Services.AddMemoryCache(); // .NET'in built-in bellek cache'i
builder.Services.AddSingleton<ICacheProvider, MemoryCacheProvider>();
builder.Services.AddSingleton<ParityCache>();
builder.Services.AddSingleton<CacheInvalidator>();

// Add authentication services
builder.Services.AddSingleton<LivePriceBackend.Services.Hub.IHubAuthenticationService, LivePriceBackend.Services.Hub.HubAuthenticationService>();
builder.Services.AddSingleton<LivePriceBackend.Services.Hub.IConnectionManagementService, LivePriceBackend.Services.Hub.ConnectionManagementService>();

// Add HaremService configuration
builder.Services.Configure<HaremServiceOptions>(builder.Configuration.GetSection("HaremService"));

// Add XmlParityService configuration
builder.Services.Configure<XmlParityServiceOptions>(builder.Configuration.GetSection("XmlParityService"));

// Register API Rate Limiter
builder.Services.AddSingleton<RateLimiter>();

// Register ParityCalculationService
builder.Services.AddSingleton<IParityCalculationService, ParityCalculationService>();

// Add HttpClientFactory with Polly policies
builder.Services.AddHttpClient("HaremClient")
    .ConfigureHttpClient((serviceProvider, client) => 
    {
        var options = serviceProvider.GetRequiredService<IOptions<HaremServiceOptions>>().Value;
        client.Timeout = TimeSpan.FromSeconds(options.TimeoutSeconds);
    })
    .AddTransientHttpErrorPolicy(policy => policy
        .WaitAndRetryAsync(
            retryCount: builder.Configuration.GetValue<int>("HaremService:RetryCount"),
            sleepDurationProvider: _ => 
                TimeSpan.FromSeconds(builder.Configuration.GetValue<int>("HaremService:RetryIntervalSeconds")),
            onRetry: (_, _, retryAttempt, _) =>
            {
                var logger = builder.Services.BuildServiceProvider().GetRequiredService<ILogger<Program>>();
                logger.LogWarning("HaremService API çağrısı başarısız oldu, {RetryAttempt}. deneme", retryAttempt);
            }
        )
    )
    .AddTransientHttpErrorPolicy(policy => policy.CircuitBreakerAsync(
        handledEventsAllowedBeforeBreaking: 3,
        durationOfBreak: TimeSpan.FromSeconds(30),
        onBreak: (_, timespan) =>
        {
            var logger = builder.Services.BuildServiceProvider().GetRequiredService<ILogger<Program>>();
            logger.LogError("HaremService API çağrısı için devre kesici devreye girdi, {TimeSpan} saniye boyunca devreden çıkacak", timespan.TotalSeconds);
        },
        onReset: () =>
        {
            var logger = builder.Services.BuildServiceProvider().GetRequiredService<ILogger<Program>>();
            logger.LogInformation("HaremService API için devre kesici sıfırlandı");
        }
    ));

// Add HttpClientFactory for XmlParityService
builder.Services.AddHttpClient("XmlParityClient")
    .ConfigureHttpClient((serviceProvider, client) => 
    {
        var options = serviceProvider.GetRequiredService<IOptions<XmlParityServiceOptions>>().Value;
        client.Timeout = TimeSpan.FromSeconds(options.TimeoutSeconds);
    })
    .AddTransientHttpErrorPolicy(policy => policy
        .WaitAndRetryAsync(
            retryCount: builder.Configuration.GetValue<int>("XmlParityService:RetryCount"),
            sleepDurationProvider: _ => 
                TimeSpan.FromSeconds(builder.Configuration.GetValue<int>("XmlParityService:RetryIntervalSeconds")),
            onRetry: (_, _, retryAttempt, _) =>
            {
                var logger = builder.Services.BuildServiceProvider().GetRequiredService<ILogger<Program>>();
                logger.LogWarning("XmlParityService API çağrısı başarısız oldu, {RetryAttempt}. deneme", retryAttempt);
            }
        )
    )
    .AddTransientHttpErrorPolicy(policy => policy.CircuitBreakerAsync(
        handledEventsAllowedBeforeBreaking: 3,
        durationOfBreak: TimeSpan.FromSeconds(30),
        onBreak: (_, timespan) =>
        {
            var logger = builder.Services.BuildServiceProvider().GetRequiredService<ILogger<Program>>();
            logger.LogError("XmlParityService API çağrısı için devre kesici devreye girdi, {TimeSpan} saniye boyunca devreden çıkacak", timespan.TotalSeconds);
        },
        onReset: () =>
        {
            var logger = builder.Services.BuildServiceProvider().GetRequiredService<ILogger<Program>>();
            logger.LogInformation("XmlParityService API için devre kesici sıfırlandı");
        }
    ));

// Register HaremService as a scoped service
builder.Services.AddScoped<IHaremService, HaremService>();

// Register XmlParityService as a scoped service
builder.Services.AddScoped<IXmlParityService, XmlParityService>();

// JWT Configuration
var jwtSettings = builder.Configuration.GetSection("JwtSettings");
var key = Encoding.ASCII.GetBytes(jwtSettings["Key"] ?? string.Empty);

builder.Services.AddSingleton<IJwtService, JwtService>();

builder.Services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(options =>
    {
        options.SaveToken = true;
        options.RequireHttpsMetadata = false;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ClockSkew = TimeSpan.Zero,
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtSettings["Issuer"],
            ValidAudience = jwtSettings["Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(key)
        };
    });

// CORS Configuration
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", corsPolicyBuilder =>
    {
        corsPolicyBuilder
            .SetIsOriginAllowed(_ => true)
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials();
    });
});

builder.Services.AddAuthorization();
builder.Services.AddControllers(options =>
{
    options.Filters.Add<ApiExceptionFilterAttribute>();
});
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "LivePriceBackend", Version = "v1" });
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "JWT token kullanarak kimlik doğrulama yapın. '{token}' formatında giriniz."
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new List<string>()
        }
    });
});

// SignalR ekliyoruz
builder.Services.AddSignalR(options =>
{
    options.EnableDetailedErrors = true;
    options.HandshakeTimeout = TimeSpan.FromSeconds(30);
    options.ClientTimeoutInterval = TimeSpan.FromSeconds(60);
    options.KeepAliveInterval = TimeSpan.FromSeconds(15);
    options.MaximumReceiveMessageSize = 102400000; // 100 MB
});

// Background Service ekliyoruz
builder.Services.AddHostedService<ParityBroadcastService>();

var app = builder.Build();

// Middleware'leri sıralı olarak ekle
// 1. Global exception middleware (tüm istekler için)
app.UseMiddleware<GlobalExceptionMiddleware>();

// 2. İstek/yanıt loglama middleware'i (performans ve detaylı loglama için)
app.UseMiddleware<RequestLoggingMiddleware>();

// Swagger UI ekleyelim
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// HTTPS yönlendirme ayarları
if (!app.Environment.IsDevelopment())
{
    app.UseHttpsRedirection();
}
else
{
    // Geliştirme ortamında HTTPS'i devre dışı bırak
    app.Use((context, next) =>
    {
        context.Request.Scheme = "http";
        return next();
    });
}

app.UseRouting(); // Routing'i CORS'dan önce ekle
app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();

// SignalR Hub'ı yapılandırıyoruz
app.MapHub<ParityHub>("/parityhub", options =>
{
    options.Transports = Microsoft.AspNetCore.Http.Connections.HttpTransportType.WebSockets |
                        Microsoft.AspNetCore.Http.Connections.HttpTransportType.LongPolling;
    options.WebSockets.CloseTimeout = TimeSpan.FromSeconds(30);
    options.LongPolling.PollTimeout = TimeSpan.FromSeconds(30);
}).AllowAnonymous();

app.MapControllers()
    .RequireAuthorization();

app.Run();