package app

import (
	"github.com/gofiber/fiber/v3"
	"github.com/jackc/pgx/v5/pgxpool"

	"cpip/internal/api"
	"cpip/shared/config"
	"cpip/shared/database"
	"cpip/shared/jobs"
	"cpip/shared/logger"
	"cpip/shared/middleware"
)

type Runtime struct {
	Config   config.Config
	Logger   *logger.Logger
	DB       *pgxpool.Pool
	JobQueue jobs.Queue
	App      *fiber.App
}

func Bootstrap() (*Runtime, error) {
	cfg := config.Load()
	logr := logger.New()

	dsn, err := database.ResolveDatabaseURL(cfg)
	if err != nil {
		return nil, err
	}
	dbpool, err := database.NewPostgresPool(dsn)
	if err != nil {
		return nil, err
	}

	jobQueue := jobs.NewInMemoryQueue(logr)
	app := fiber.New(fiber.Config{
		AppName:      "CPIP Backend",
		ServerHeader: "cpip",
		ErrorHandler: middleware.ErrorHandler,
	})
	middleware.RegisterGlobal(app, logr)
	api.RegisterRoutes(app, api.Dependencies{
		Config:   cfg,
		Logger:   logr,
		DB:       dbpool,
		JobQueue: jobQueue,
	})

	return &Runtime{
		Config:   cfg,
		Logger:   logr,
		DB:       dbpool,
		JobQueue: jobQueue,
		App:      app,
	}, nil
}
