using System.Linq.Expressions;
using LivePriceBackend.Core.Entities.Infrastructure;
using LivePriceBackend.Entities;
using Microsoft.EntityFrameworkCore;
using ProductAPI.Services.User;

namespace LivePriceBackend.Data
{
    public class LivePriceDbContext(DbContextOptions<LivePriceDbContext> options, IUserService userService) : DbContext(options)
    {
        public DbSet<User> Users { get; set; }
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Parity> Parities { get; set; }
        public DbSet<ParityGroup> ParityGroups { get; set; }
        public DbSet<CustomerPriceRule> CustomerPriceRules { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            
            // Tüm DateTime özelliklerini milisaniye olmadan saklamak için yapılandırma
            foreach (var entityType in modelBuilder.Model.GetEntityTypes())
            {
                foreach (var property in entityType.GetProperties())
                {
                    if (property.ClrType == typeof(DateTime) || property.ClrType == typeof(DateTime?))
                    {
                        property.SetColumnType("datetime2(0)");
                    }
                }
            }

            
            // Tüm entityler için soft delete filtresi ekleme
            foreach (var entityType in modelBuilder.Model.GetEntityTypes())
            {
                if (!typeof(AuditableEntity).IsAssignableFrom(entityType.ClrType)) continue;
                var parameter = Expression.Parameter(entityType.ClrType, "e");
                var propertyAccess = Expression.Property(parameter, "IsDeleted");
                var notExpression = Expression.Not(propertyAccess);
                var lambda = Expression.Lambda(notExpression, parameter);
                modelBuilder.Entity(entityType.ClrType).HasQueryFilter(lambda);
            }
            
            modelBuilder.ApplyConfigurationsFromAssembly(typeof(LivePriceDbContext).Assembly);
        }

        public override int SaveChanges()
        {
            UpdateAuditFields();
            return base.SaveChanges();
        }

        public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            UpdateAuditFields();
            return base.SaveChangesAsync(cancellationToken);
        }

        private void UpdateAuditFields()
        {
            var entries = ChangeTracker.Entries()
                .Where(e => e.Entity is AuditableEntity && 
                            (e.State == EntityState.Added || e.State == EntityState.Modified || e.State == EntityState.Deleted));

            var currentTime = DateTime.UtcNow;
            var currentUserId = userService.GetCurrentUserId();

            foreach (var entry in entries)
            {
                var entity = (AuditableEntity)entry.Entity;
                
                switch (entry.State)
                {
                    case EntityState.Added:
                        entity.CreatedAt = currentTime;
                        entity.CreatedById = currentUserId;
                        entity.IsDeleted = false;
                        break;

                    case EntityState.Modified:
                        entity.UpdatedAt = currentTime;
                        entity.UpdatedById = currentUserId;
                        break;

                    case EntityState.Deleted:
                        entry.State = EntityState.Modified;
                        entity.IsDeleted = true;
                        entity.DeletedAt = currentTime;
                        entity.DeletedById = currentUserId;
                        break;
                    case EntityState.Detached:
                        break;
                    case EntityState.Unchanged:
                        break;
                    default:
                        throw new ArgumentOutOfRangeException();
                }
            }
        }
    }
}