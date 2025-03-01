using LivePriceBackend.Core.Entities.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LivePriceBackend.Extensions;

public static class AuditableEntityConfigurationExtensions
{
    public static void ConfigureAuditableEntity<TEntity>(this EntityTypeBuilder<TEntity> builder) where TEntity : AuditableEntity
    {
        builder.Property(e => e.CreatedAt)
            .HasColumnType("datetime2(0)");
        builder.Property(e => e.UpdatedAt)
            .HasColumnType("datetime2(0)");
        builder.Property(e => e.DeletedAt)
            .HasColumnType("datetime2(0)");
        builder.Property(e => e.CreatedById);
        builder.Property(e => e.UpdatedById);
        builder.Property(e => e.DeletedById);
        builder.Property(e => e.IsDeleted);

        builder.HasOne(e => e.CreatedBy)
            .WithMany()
            .HasForeignKey(e => e.CreatedById);

        builder.HasOne(e => e.UpdatedBy)
            .WithMany()
            .HasForeignKey(e => e.UpdatedById);

        builder.HasOne(e => e.DeletedBy)
            .WithMany()
            .HasForeignKey(e => e.DeletedById);
    }
}