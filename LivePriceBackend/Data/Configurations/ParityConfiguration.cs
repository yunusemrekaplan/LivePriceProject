using LivePriceBackend.Entities;
using LivePriceBackend.Extensions;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LivePriceBackend.Data.Configurations;

public class ParityConfiguration : IEntityTypeConfiguration<Parity>
{
    public void Configure(EntityTypeBuilder<Parity> builder)
    {
        builder.ToTable("Parities");
        builder.HasKey(p => p.Id);
        
        builder.Property(p => p.Name)
            .IsRequired()
            .HasMaxLength(50);
        
        builder.Property(p => p.Symbol)
            .IsRequired()
            .HasMaxLength(50);
        
        builder.Property(p => p.OrderIndex)
            .IsRequired();
        
        builder.Property(p => p.ParityGroupId)
            .IsRequired();
        
        builder.Property(p => p.IsEnabled)
            .IsRequired()
            .HasDefaultValue(true);
        
        builder.HasOne(p => p.ParityGroup)
            .WithMany(pg => pg.Parities)
            .HasForeignKey(p => p.ParityGroupId)
            .OnDelete(DeleteBehavior.Cascade);
        
        builder.HasMany(p => p.CustomerPriceRules)
            .WithOne(c => c.Parity)
            .HasForeignKey(c => c.ParityId)
            .OnDelete(DeleteBehavior.Cascade);
        
        builder.ConfigureAuditableEntity();
    }
}