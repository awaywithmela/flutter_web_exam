using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace BackendAPI.Data;

public class AppDbContextFactory : IDesignTimeDbContextFactory<AppDbContext>
{
    public AppDbContext CreateDbContext(string[] args)
    {
        var configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: true)
            .AddJsonFile("appsettings.Development.json", optional: true)
            .AddEnvironmentVariables()
            .Build();

        var databaseUrl = DatabaseConnection.Normalize(
            configuration["DATABASE_URL"]
                ?? throw new InvalidOperationException("DATABASE_URL is not configured."));

        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseNpgsql(databaseUrl)
            .Options;

        return new AppDbContext(options);
    }
}
