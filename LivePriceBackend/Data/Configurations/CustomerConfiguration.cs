using LivePriceBackend.Entities;
using LivePriceBackend.Extensions;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LivePriceBackend.Data.Configurations;

public class CustomerConfiguration : IEntityTypeConfiguration<Customer>
{
    public void Configure(EntityTypeBuilder<Customer> builder)
    {
        builder.ToTable("Customers");
        builder.HasKey(c => c.Id);
        
        builder.Property(c => c.Name)
            .IsRequired()
            .HasMaxLength(50);
        
        builder.Property(c => c.ApiKey)
            .IsRequired()
            .HasMaxLength(50);
        
        builder.HasMany(c => c.Users)
            .WithOne(p => p.Customer)
            .HasForeignKey(p => p.CustomerId)
            .OnDelete(DeleteBehavior.Cascade);
        
        builder.HasMany(c => c.CustomerPriceRules)
            .WithOne(p => p.Customer)
            .HasForeignKey(p => p.CustomerId)
            .OnDelete(DeleteBehavior.Cascade);
        
        builder.ConfigureAuditableEntity();
    }
}