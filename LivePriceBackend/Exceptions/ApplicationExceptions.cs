namespace LivePriceBackend.Exceptions;

/// <summary>
/// Uygulama temel exception sınıfı
/// </summary>
public class ApplicationException : Exception
{
    public ApplicationException(string message) : base(message)
    {
    }

    public ApplicationException(string message, Exception innerException) : base(message, innerException)
    {
    }
}

/// <summary>
/// Kaynak bulunamadığında fırlatılır
/// </summary>
public class NotFoundException : ApplicationException
{
    public NotFoundException(string name, object key)
        : base($"Kaynak bulunamadı: '{name}' (Anahtar: {key})")
    {
    }
}

/// <summary>
/// Yetkilendirme hatası
/// </summary>
public class ForbiddenAccessException : ApplicationException
{
    public ForbiddenAccessException() : base("Bu işlem için gerekli yetkiniz bulunmuyor.")
    {
    }
    
    public ForbiddenAccessException(string message) : base(message)
    {
    }
}

/// <summary>
/// İş kuralı ihlali
/// </summary>
public class BusinessRuleException : ApplicationException
{
    public BusinessRuleException(string message) : base(message)
    {
    }
}

/// <summary>
/// Veri bütünlüğü hatası
/// </summary>
public class DataIntegrityException : ApplicationException
{
    public DataIntegrityException(string message) : base(message)
    {
    }
}

/// <summary>
/// Dış servis hatası
/// </summary>
public class ExternalServiceException : ApplicationException
{
    public string ServiceName { get; }
    
    public ExternalServiceException(string serviceName, string message) 
        : base($"{serviceName} servisinde hata: {message}")
    {
        ServiceName = serviceName;
    }
    
    public ExternalServiceException(string serviceName, string message, Exception innerException) 
        : base($"{serviceName} servisinde hata: {message}", innerException)
    {
        ServiceName = serviceName;
    }
} 