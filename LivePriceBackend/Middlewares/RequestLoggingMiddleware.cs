using System.Diagnostics;
using Microsoft.AspNetCore.Http;
using Microsoft.IO;

namespace LivePriceBackend.Middlewares;

/// <summary>
/// Gelen istekleri ve cevapları loglar, performans metriklerini toplar
/// </summary>
public class RequestLoggingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<RequestLoggingMiddleware> _logger;

    public RequestLoggingMiddleware(RequestDelegate next, ILogger<RequestLoggingMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        // İstek bilgilerini al
        var method = context.Request.Method;
        var path = context.Request.Path;
        
        // Başlangıç zamanı
        var stopwatch = Stopwatch.StartNew();

        // Yalnızca kritik durumlarda logla (500 hataları, uzun süren istekler)
        try
        {
            // Bir sonraki middleware'e geç
            await _next(context);

            stopwatch.Stop();
            var elapsedMs = stopwatch.ElapsedMilliseconds;
            var statusCode = context.Response.StatusCode;

            // Sadece uzun süren istekleri veya hata durumlarını logla
            if (elapsedMs > 500 || statusCode >= 400) 
            {
                var logLevel = statusCode >= 500 ? LogLevel.Error : statusCode >= 400 ? LogLevel.Warning : LogLevel.Information;
                
                _logger.Log(
                    logLevel,
                    "HTTP {Method} {Path} tamamlandı - Durum: {StatusCode} - Süre: {ElapsedMilliseconds}ms",
                    method, path, statusCode, elapsedMs);
            }
        }
        catch (Exception)
        {
            stopwatch.Stop();
            _logger.LogError(
                "HTTP {Method} {Path} sırasında işlenmeyen hata - Süre: {ElapsedMilliseconds}ms",
                method, path, stopwatch.ElapsedMilliseconds);
            throw; // Hatayı tekrar fırlat, global exception middleware bunu yakalayacak
        }
    }
} 