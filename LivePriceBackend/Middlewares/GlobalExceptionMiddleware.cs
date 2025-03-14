using System.Net;
using System.Text.Json;
using Microsoft.AspNetCore.Http;

namespace LivePriceBackend.Middlewares;

/// <summary>
/// Tüm uygulama genelinde hataları yakalar ve işler
/// </summary>
public class GlobalExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<GlobalExceptionMiddleware> _logger;
    private readonly IWebHostEnvironment _env;

    public GlobalExceptionMiddleware(
        RequestDelegate next, 
        ILogger<GlobalExceptionMiddleware> logger,
        IWebHostEnvironment env)
    {
        _next = next;
        _logger = logger;
        _env = env;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            await HandleExceptionAsync(context, ex);
        }
    }

    private async Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        context.Response.ContentType = "application/json";
        
        var statusCode = exception switch
        {
            ArgumentException => (int)HttpStatusCode.BadRequest,
            KeyNotFoundException => (int)HttpStatusCode.NotFound,
            UnauthorizedAccessException => (int)HttpStatusCode.Unauthorized,
            _ => (int)HttpStatusCode.InternalServerError
        };
        
        context.Response.StatusCode = statusCode;

        // Loglama seviyesini belirle
        if (statusCode == 500)
        {
            _logger.LogError(exception, "Sunucu hatası: {Message}", exception.Message);
        }
        else
        {
            _logger.LogWarning(exception, "İstemci hatası: {StatusCode} - {Message}", statusCode, exception.Message);
        }

        // Cevap objesi
        var response = new 
        {
            status = statusCode,
            message = exception.Message,
            // Geliştirme ortamında ek detaylar göster
            detail = _env.IsDevelopment() ? exception.StackTrace : null,
            errors = GetErrors(exception)
        };

        await context.Response.WriteAsync(JsonSerializer.Serialize(response));
    }

    private static IEnumerable<string> GetErrors(Exception exception)
    {
        var errors = new List<string>();
        if (exception is AggregateException aggregateException)
        {
            errors.AddRange(aggregateException.InnerExceptions.Select(e => e.Message));
        }
        else if (exception.InnerException != null)
        {
            errors.Add(exception.InnerException.Message);
        }
        return errors;
    }
} 