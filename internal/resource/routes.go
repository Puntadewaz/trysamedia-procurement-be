package resource

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/middleware"
	"cpip/shared/response"
	"cpip/shared/validator"
)

type resourceRequest struct {
	EmployeeCode string `json:"employee_code" validate:"required,min=2,max=50"`
	Name         string `json:"name" validate:"required,min=2,max=150"`
	RoleTitle    string `json:"role_title" validate:"required,min=2,max=100"`
	ManagerUser  string `json:"manager_user_id" validate:"omitempty,uuid4"`
}

func RegisterRoutes(secured fiber.Router) {
	secured.Get("/resources", middleware.RequirePermission("resource.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
	secured.Post("/resources", middleware.RequirePermission("resource.create"), func(c fiber.Ctx) error {
		var req resourceRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusCreated, fiber.Map{"id": uuid.NewString(), "employee_code": req.EmployeeCode}, nil)
	})
	secured.Get("/resources/allocations", middleware.RequirePermission("resource.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
}
