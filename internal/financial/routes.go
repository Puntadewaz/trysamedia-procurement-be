package financial

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/middleware"
	"cpip/shared/response"
	"cpip/shared/validator"
)

type financialRequest struct {
	AsOfDate string  `json:"as_of_date" validate:"required"`
	Currency string  `json:"currency" validate:"required,len=3"`
	Budget   float64 `json:"budget" validate:"gte=0"`
	Actual   float64 `json:"actual" validate:"gte=0"`
	Forecast float64 `json:"forecast" validate:"gte=0"`
}

func RegisterRoutes(secured fiber.Router) {
	group := secured.Group("/projects/:id/financials")
	group.Get("/", middleware.RequirePermission("financial.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
	group.Post("/", middleware.RequirePermission("financial.create"), func(c fiber.Ctx) error {
		var req financialRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusCreated, fiber.Map{"id": uuid.NewString(), "project_id": c.Params("id")}, nil)
	})
}
