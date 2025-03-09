using LivePriceBackend.Entities;
using LivePriceBackend.Extensions;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LivePriceBackend.Data.Configurations;

public class CParityRuleConfiguration : IEntityTypeConfiguration<CParityRule>
{
    public void Configure(EntityTypeBuilder<CParityRule> builder)
    {
        builder.ToTable("CParityRules");
        builder.HasKey(cpr => cpr.Id);

        builder.Property(cpr => cpr.IsVisible)
            .HasDefaultValue(true)
            .IsRequired();

        builder.Property(cpr => cpr.SpreadRuleType)
            .IsRequired(false);

        builder.Property(cpr => cpr.SpreadForAsk)
            .HasColumnType("decimal(18, 6)");

        builder.Property(cpr => cpr.SpreadForBid)
            .HasColumnType("decimal(18, 6)");

        builder.HasOne(cpr => cpr.Parity)
            .WithMany(p => p.CParityRules)
            .HasForeignKey(cpr => cpr.ParityId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.ConfigureAuditableEntity();
    }
}