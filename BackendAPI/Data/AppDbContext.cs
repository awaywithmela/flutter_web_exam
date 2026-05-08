using BackendAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BackendAPI.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<User> Users => Set<User>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasIndex(user => user.Email).IsUnique();
            entity.Property(user => user.FirstName).HasMaxLength(100).IsRequired();
            entity.Property(user => user.MiddleName).HasMaxLength(100);
            entity.Property(user => user.LastName).HasMaxLength(100).IsRequired();
            entity.Property(user => user.Email).HasMaxLength(255).IsRequired();
            entity.Property(user => user.PasswordHash).IsRequired();
            entity.Property(user => user.PhoneNumber).HasMaxLength(40);
            entity.Property(user => user.Gender).HasMaxLength(40);
            entity.Property(user => user.City).HasMaxLength(100);
            entity.Property(user => user.Country).HasMaxLength(100);
        });
    }
}
