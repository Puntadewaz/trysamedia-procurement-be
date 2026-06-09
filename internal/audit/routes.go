package audit

import (
	"github.com/gofiber/fiber/v3"

	"cpip/shared/middleware"
	"cpip/shared/response"
)

func RegisterRoutes(secured fiber.Router) {
	secured.Get("/audit-logs", middleware.RequirePermission("audit.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
}
