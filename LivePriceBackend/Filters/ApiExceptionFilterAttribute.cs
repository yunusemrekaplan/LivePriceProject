using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace LivePriceBackend.Filters;

/// <summary>
/// API isteklerinde oluşan hataları yakalar ve uygun formatta döndürür
/// </summary>
[AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
public class ApiExceptionFilterAttribute : ExceptionFilterAttribute
{
    private readonly IWebHostEnvironment _env;
    private readonly ILogger<ApiExceptionFilterAttribute> _logger;

    /// <summary>
    /// Bu filtreyi API kontrolcülerine uygulamak için kullanın
    /// </summary>
    public ApiExceptionFilterAttribute(
        IWebHostEnvironment env,
        ILogger<ApiExceptionFilterAttribute> logger)
    {
        _env = env;
        _logger = logger;
    }

    public override void OnException(ExceptionContext context)
    {
        var exception = context.Exception;
        var statusCode = GetStatusCode(exception);
        
        // Loglama işlemi
        if (statusCode == (int)HttpStatusCode.InternalServerError)
        {
            _logger.LogError(exception, "API hatası: {Path} - {Message}", 
                context.HttpContext.Request.Path, exception.Message);
        }
        else
        {
            _logger.LogWarning(exception, "API istemci hatası: {Path} - {StatusCode} - {Message}", 
                context.HttpContext.Request.Path, statusCode, exception.Message);
        }

        // API yanıtını oluştur
        var response = new
        {
            status = statusCode,
            title = GetTitle(exception),
            message = exception.Message,
            detail = _env.IsDevelopment() ? exception.StackTrace : null
        };

        context.Result = new ObjectResult(response) { StatusCode = statusCode };
        context.ExceptionHandled = true;
    }

    private static int GetStatusCode(Exception exception)
    {
        return exception switch
        {
            ArgumentException => (int)HttpStatusCode.BadRequest,
            KeyNotFoundException => (int)HttpStatusCode.NotFound,
            UnauthorizedAccessException => (int)HttpStatusCode.Unauthorized,
            InvalidOperationException => (int)HttpStatusCode.BadRequest,
            _ => (int)HttpStatusCode.InternalServerError
        };
    }

    private static string GetTitle(Exception exception)
    {
        return exception switch
        {
            ArgumentException => "Geçersiz Parametre",
            KeyNotFoundException => "Kaynak Bulunamadı",
            UnauthorizedAccessException => "Yetkisiz Erişim",
            InvalidOperationException => "Geçersiz İşlem",
            _ => "Sunucu Hatası"
        };
    }
} 