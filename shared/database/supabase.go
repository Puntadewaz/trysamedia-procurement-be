package database

import (
	"errors"
	"strings"

	"cpip/shared/config"
)

func ResolveDatabaseURL(cfg config.Config) (string, error) {
	if strings.TrimSpace(cfg.SupabaseDBURL) != "" {
		return cfg.SupabaseDBURL, nil
	}
	if strings.TrimSpace(cfg.DatabaseURL) != "" {
		return cfg.DatabaseURL, nil
	}
	return "", errors.New("no database URL configured (SUPABASE_DB_URL or DATABASE_URL)")
}
