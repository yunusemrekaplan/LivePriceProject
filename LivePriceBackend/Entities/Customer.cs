﻿using LivePriceBackend.Core.Entities.Infrastructure;

namespace LivePriceBackend.Entities;

public class Customer : AuditableEntity
{
    public string Name { get; set; }
    public string ApiKey { get; set; } // API erişimi için
    public bool IsEnabled { get; set; } = true; // Hesap aktif mi

    public ICollection<User> Users { get; set; } = [];
}