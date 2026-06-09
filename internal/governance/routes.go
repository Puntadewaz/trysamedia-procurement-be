package governance

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/middleware"
	"cpip/shared/response"
	"cpip/shared/validator"
)

type reviewRequest struct {
	ProjectID  string `json:"project_id" validate:"required,uuid4"`
	ReviewDate string `json:"review_date" validate:"required"`
	Outcome    string `json:"outcome" validate:"required,oneof=approved conditional rejected"`
	Notes      string `json:"notes" validate:"omitempty,max=5000"`
}

func RegisterRoutes(secured fiber.Router) {
	secured.Get("/governance-reviews", middleware.RequirePermission("governance.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
	secured.Post("/governance-reviews", middleware.RequirePermission("governance.create"), func(c fiber.Ctx) error {
		var req reviewRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusCreated, fiber.Map{"id": uuid.NewString(), "project_id": req.ProjectID}, nil)
	})
}
