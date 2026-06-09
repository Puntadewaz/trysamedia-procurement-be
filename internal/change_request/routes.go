package change_request

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/middleware"
	"cpip/shared/response"
	"cpip/shared/validator"
)

type changeRequest struct {
	ProjectID   string  `json:"project_id" validate:"required,uuid4"`
	Code        string  `json:"code" validate:"required,min=2,max=40"`
	ChangeType  string  `json:"change_type" validate:"required,oneof=scope budget timeline quality"`
	ImpactCost  float64 `json:"impact_cost" validate:"gte=0"`
	ImpactDays  int     `json:"impact_days" validate:"gte=0"`
	Description string  `json:"description" validate:"required,min=5,max=2000"`
}

func RegisterRoutes(secured fiber.Router) {
	secured.Get("/change-requests", middleware.RequirePermission("change.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
	secured.Post("/change-requests", middleware.RequirePermission("change.create"), func(c fiber.Ctx) error {
		var req changeRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusCreated, fiber.Map{"id": uuid.NewString(), "code": req.Code}, nil)
	})
}
