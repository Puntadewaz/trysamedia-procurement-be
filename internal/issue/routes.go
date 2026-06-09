package issue

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/middleware"
	"cpip/shared/response"
	"cpip/shared/validator"
)

type issueRequest struct {
	ProjectID   string `json:"project_id" validate:"required,uuid4"`
	Code        string `json:"code" validate:"required,min=2,max=40"`
	Title       string `json:"title" validate:"required,min=2,max=250"`
	Severity    string `json:"severity" validate:"required,oneof=low medium high critical"`
	Status      string `json:"status" validate:"omitempty,oneof=open in_progress resolved closed"`
	AssignedTo  string `json:"assigned_to" validate:"omitempty,uuid4"`
}

func RegisterRoutes(secured fiber.Router) {
	secured.Get("/issues", middleware.RequirePermission("issue.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
	secured.Post("/issues", middleware.RequirePermission("issue.create"), func(c fiber.Ctx) error {
		var req issueRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusCreated, fiber.Map{"id": uuid.NewString(), "code": req.Code}, nil)
	})
}
