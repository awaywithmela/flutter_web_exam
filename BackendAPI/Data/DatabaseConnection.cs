using Microsoft.AspNetCore.WebUtilities;

namespace BackendAPI.Data;

public static class DatabaseConnection
{
    public static string Normalize(string connectionString)
    {
        if (!Uri.TryCreate(connectionString, UriKind.Absolute, out var uri)
            || (uri.Scheme != "postgresql" && uri.Scheme != "postgres"))
        {
            return connectionString;
        }

        var userInfo = uri.UserInfo.Split(':', 2);
        var username = Uri.UnescapeDataString(userInfo.ElementAtOrDefault(0) ?? string.Empty);
        var password = Uri.UnescapeDataString(userInfo.ElementAtOrDefault(1) ?? string.Empty);
        var database = Uri.UnescapeDataString(uri.AbsolutePath.TrimStart('/'));
        var query = QueryHelpers.ParseQuery(uri.Query);

        var parts = new List<string>
        {
            $"Host={uri.Host}",
            $"Database={database}",
            $"Username={username}",
            $"Password={password}"
        };

        if (uri.Port > 0)
        {
            parts.Insert(1, $"Port={uri.Port}");
        }

        if (query.TryGetValue("sslmode", out var sslMode))
        {
            parts.Add($"SSL Mode={sslMode}");
        }

        if (query.TryGetValue("channel_binding", out var channelBinding))
        {
            parts.Add($"Channel Binding={channelBinding}");
        }

        return string.Join(';', parts);
    }
}
