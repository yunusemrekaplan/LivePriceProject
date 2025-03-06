using LivePriceBackend.Entities;
using LivePriceBackend.Extensions;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LivePriceBackend.Data.Configurations;

public class CustomerPriceRuleConfiguration : IEntityTypeConfiguration<CustomerPriceRule>
{
    public void Configure(EntityTypeBuilder<CustomerPriceRule> builder)
    {
        builder.ToTable("CustomerPriceRules");
        builder.HasKey(c => c.Id);
        
        builder.HasOne(c => c.Customer)
            .WithMany(p => p.CustomerPriceRules)
            .HasForeignKey(p => p.CustomerId)
            .OnDelete(DeleteBehavior.Cascade);
        
        builder.HasOne(c => c.Parity)
            .WithMany(p => p.CustomerPriceRules)
            .HasForeignKey(p => p.ParityId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.Property(c => c.SpreadRuleType)
            .IsRequired();
        
        builder.Property(c => c.Value)
            .IsRequired();
        
        builder.ConfigureAuditableEntity();
    }
}