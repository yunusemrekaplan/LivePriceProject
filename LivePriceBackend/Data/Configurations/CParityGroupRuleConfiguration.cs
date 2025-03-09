using LivePriceBackend.Entities;
using LivePriceBackend.Extensions;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LivePriceBackend.Data.Configurations;

public class CParityGroupRuleConfiguration : IEntityTypeConfiguration<CParityGroupRule>
{
    public void Configure(EntityTypeBuilder<CParityGroupRule> builder)
    {
        builder.ToTable("CParityGroupRules");
        builder.HasKey(cpr => cpr.Id);

        builder.Property(cpr => cpr.IsVisible)
            .HasDefaultValue(true)
            .IsRequired();
        

        builder.HasOne(cpr => cpr.ParityGroup)
            .WithMany(p => p.CParityGroupRules)
            .HasForeignKey(cpr => cpr.ParityGroupId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.ConfigureAuditableEntity();
    }
}