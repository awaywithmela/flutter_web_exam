# BackendAPI

ASP.NET Core 8 Web API for JWT authentication and user profile management.

## Configuration

Set these values in your host environment:

```env
DATABASE_URL=Host=...;Database=...;Username=...;Password=...;SSL Mode=Require
JWT_SECRET=replace_with_a_long_random_secret
```

## Run locally

```bash
dotnet restore
dotnet ef database update
dotnet run
```

Swagger is available in development at `/swagger`.
