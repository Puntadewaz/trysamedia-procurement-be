package config

import (
	"os"
	"strings"
)

type Config struct {
	HTTPAddr         string
	DatabaseURL      string
	SupabaseDBURL    string
	SupabaseURL      string
	SupabaseAnonKey  string
	SupabaseServiceKey string
	JWTIssuer        string
	JWTAudience      string
	JWTAccessSecret  string
	JWTRefreshSecret string
}

// ResolveHTTPAddr returns the listen address for long-running servers.
// On Vercel/Railway/Render, PORT is injected and must take precedence over HTTP_ADDR.
func ResolveHTTPAddr() string {
	if port := strings.TrimSpace(os.Getenv("PORT")); port != "" {
		return ":" + port
	}
	return getEnv("HTTP_ADDR", ":8080")
}

func Load() Config {
	return Config{
		HTTPAddr:         ResolveHTTPAddr(),
		DatabaseURL:      getEnv("DATABASE_URL", "postgres://postgres:postgres@localhost:5432/cpip?sslmode=disable"),
		SupabaseDBURL:    os.Getenv("SUPABASE_DB_URL"),
		SupabaseURL:      os.Getenv("SUPABASE_URL"),
		SupabaseAnonKey:  os.Getenv("SUPABASE_ANON_KEY"),
		SupabaseServiceKey: os.Getenv("SUPABASE_SERVICE_ROLE_KEY"),
		JWTIssuer:        getEnv("JWT_ISSUER", "cpip"),
		JWTAudience:      getEnv("JWT_AUDIENCE", "cpip-api"),
		JWTAccessSecret:  getEnv("JWT_ACCESS_SECRET", "change-me-access"),
		JWTRefreshSecret: getEnv("JWT_REFRESH_SECRET", "change-me-refresh"),
	}
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
