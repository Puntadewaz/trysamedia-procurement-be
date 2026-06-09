package api

import (
	"github.com/gofiber/fiber/v3"
	"github.com/jackc/pgx/v5/pgxpool"

	"cpip/internal/analytics"
	"cpip/internal/audit"
	"cpip/internal/change_request"
	"cpip/internal/financial"
	"cpip/internal/governance"
	"cpip/internal/iam"
	"cpip/internal/import_engine"
	"cpip/internal/integration"
	"cpip/internal/issue"
	"cpip/internal/portfolio"
	"cpip/internal/project"
	"cpip/internal/reporting"
	"cpip/internal/resource"
	"cpip/internal/risk"
	"cpip/internal/vendor"
	"cpip/shared/config"
	"cpip/shared/jobs"
	"cpip/shared/logger"
	"cpip/shared/middleware"
	"cpip/shared/response"
)

type Dependencies struct {
	Config   config.Config
	Logger   *logger.Logger
	DB       *pgxpool.Pool
	JobQueue jobs.Queue
}

func RegisterRoutes(app *fiber.App, deps Dependencies) {
	app.Get("/healthz", func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"status": "ok"}, nil)
	})
	app.Get("/readyz", func(c fiber.Ctx) error {
		if deps.DB == nil {
			return response.Error(c, fiber.StatusServiceUnavailable, "DB_NOT_READY", "database not connected")
		}
		if err := deps.DB.Ping(c.Context()); err != nil {
			return response.Error(c, fiber.StatusServiceUnavailable, "DB_NOT_READY", "database ping failed")
		}
		return response.Success(c, fiber.StatusOK, fiber.Map{"status": "ready"}, nil)
	})

	api := app.Group("/api")
	v1 := api.Group("/v1")
	iam.RegisterAuthRoutes(v1, deps.Config)

	secured := v1.Group("/", middleware.RequireJWT(deps.Config.JWTAccessSecret))
	secured.Use(middleware.RequireTenant())

	iam.RegisterUserRoutes(secured)
	portfolio.RegisterRoutes(secured)
	project.RegisterRoutes(secured)
	financial.RegisterRoutes(secured)
	resource.RegisterRoutes(secured)
	vendor.RegisterRoutes(secured)
	risk.RegisterRoutes(secured)
	issue.RegisterRoutes(secured)
	change_request.RegisterRoutes(secured)
	governance.RegisterRoutes(secured)
	integration.RegisterRoutes(secured, deps.Config)
	import_engine.RegisterRoutes(secured, deps.JobQueue)
	analytics.RegisterRoutes(secured)
	reporting.RegisterRoutes(secured)
	audit.RegisterRoutes(secured)
}
