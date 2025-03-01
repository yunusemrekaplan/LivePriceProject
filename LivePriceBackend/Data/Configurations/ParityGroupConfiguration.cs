using LivePriceBackend.Entities;
using LivePriceBackend.Extensions;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LivePriceBackend.Data.Configurations;

public class ParityGroupConfiguration : IEntityTypeConfiguration<ParityGroup>
{
    public void Configure(EntityTypeBuilder<ParityGroup> builder)
    {
        builder.ToTable("ParityGroups");
        builder.HasKey(p => p.Id);
        
        builder.Property(p => p.Name)
            .IsRequired()
            .HasMaxLength(50);
        
        builder.Property(p => p.Description)
            .IsRequired()
            .HasMaxLength(50);
        
        builder.Property(p => p.IsEnabled)
            .IsRequired()
            .HasDefaultValue(true);
        
        builder.HasMany(p => p.Parities)
            .WithOne(c => c.ParityGroup)
            .HasForeignKey(c => c.ParityGroupId)
            .OnDelete(DeleteBehavior.Cascade);
        
        builder.ConfigureAuditableEntity();
    }
    
}