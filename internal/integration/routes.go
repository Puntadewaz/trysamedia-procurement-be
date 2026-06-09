package integration

import (
	"github.com/gofiber/fiber/v3"

	"cpip/shared/config"
	"cpip/shared/middleware"
	"cpip/shared/response"
)

func RegisterRoutes(secured fiber.Router, cfg config.Config) {
	secured.Get("/integrations/supabase/status", middleware.RequirePermission("integration.read"), func(c fiber.Ctx) error {
		_, ok := NewSupabaseClient(cfg)
		return response.Success(c, fiber.StatusOK, fiber.Map{
			"configured": ok,
			"url_set":    cfg.SupabaseURL != "",
			"db_set":     cfg.SupabaseDBURL != "",
		}, nil)
	})
}
