package analytics

import (
	"github.com/gofiber/fiber/v3"

	"cpip/shared/middleware"
	"cpip/shared/response"
)

func RegisterRoutes(secured fiber.Router) {
	secured.Get("/analytics/executive-summary", middleware.RequirePermission("analytics.read.executive"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"kpis": []any{}}, nil)
	})
	secured.Get("/analytics/portfolio-health", middleware.RequirePermission("analytics.read.portfolio"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"health": []any{}}, nil)
	})
	secured.Get("/analytics/financial-performance", middleware.RequirePermission("analytics.read.financial"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"financial_performance": []any{}}, nil)
	})
	secured.Get("/analytics/resource-utilization", middleware.RequirePermission("analytics.read.resource"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"resource_utilization": []any{}}, nil)
	})
	secured.Get("/analytics/risk-exposure", middleware.RequirePermission("analytics.read.risk"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"risk_exposure": []any{}}, nil)
	})
}
