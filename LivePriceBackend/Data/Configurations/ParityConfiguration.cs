﻿using LivePriceBackend.Entities;
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

        builder.Property(p => p.RawSymbol)
            .IsRequired()
            .HasMaxLength(50);
        
        builder.Property(p => p.RawMarketCode)
            .IsRequired();

        builder.Property(p => p.IsEnabled)
            .IsRequired()
            .HasDefaultValue(true);

        builder.Property(p => p.OrderIndex)
            .IsRequired();

        builder.Property(p => p.Scale)
            .IsRequired()
            .HasDefaultValue(2);

        builder.Property(p => p.SpreadForBid)
            .HasColumnType("decimal(18, 6)");

        builder.Property(p => p.SpreadForAsk)
            .HasColumnType("decimal(18, 6)");

        builder.Property(p => p.ParityGroupId)
            .IsRequired();

        builder.HasOne(p => p.ParityGroup)
            .WithMany(pg => pg.Parities)
            .HasForeignKey(p => p.ParityGroupId)
            .OnDelete(DeleteBehavior.Cascade);
        
        builder.HasMany(p => p.CParityRules)
            .WithOne(cpr => cpr.Parity)
            .HasForeignKey(cpr => cpr.ParityId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.ConfigureAuditableEntity();
    }
}