package reporting

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/middleware"
	"cpip/shared/response"
	"cpip/shared/validator"
)

type reportGenerateRequest struct {
	ReportType string         `json:"report_type" validate:"required,oneof=executive portfolio financial resource risk vendor"`
	Format     string         `json:"format" validate:"required,oneof=pdf xlsx csv"`
	Filters    map[string]any `json:"filters"`
}

func RegisterRoutes(secured fiber.Router) {
	secured.Post("/reports/generate", middleware.RequirePermission("report.generate"), func(c fiber.Ctx) error {
		var req reportGenerateRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusAccepted, fiber.Map{"report_id": uuid.NewString(), "status": "queued"}, nil)
	})
	secured.Get("/reports", middleware.RequirePermission("report.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
	secured.Get("/reports/:id", middleware.RequirePermission("report.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"id": c.Params("id")}, nil)
	})
}
