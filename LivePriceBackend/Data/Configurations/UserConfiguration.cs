using LivePriceBackend.Entities;
using LivePriceBackend.Extensions;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LivePriceBackend.Data.Configurations;

public class UserConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {
        builder.ToTable("Users");
        builder.HasKey(u => u.Id);
        
        // Name alanı için konfigürasyon
        builder.Property(u => u.Name)
            .IsRequired()
            .HasMaxLength(50);
        
        // Surname alanı için konfigürasyon
        builder.Property(u => u.Surname)
            .IsRequired()
            .HasMaxLength(50);
        
        // Username alanı için konfigürasyon
        builder.Property(u => u.Username)
            .IsRequired()
            .HasMaxLength(50);
        
        // Email alanı için konfigürasyon
        builder.Property(u => u.Email)
            .IsRequired()
            .HasMaxLength(100);
        
        // PasswordHash alanı için konfigürasyon
        builder.Property(u => u.PasswordHash)
            .IsRequired()
            .HasMaxLength(500);
        
        // Role alanı için konfigürasyon
        builder.Property(u => u.Role)
            .IsRequired();
        
        builder.ConfigureAuditableEntity();
    }
}