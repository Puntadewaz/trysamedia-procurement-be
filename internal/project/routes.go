package project

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/middleware"
	"cpip/shared/response"
	"cpip/shared/validator"
)

type projectRequest struct {
	PortfolioID   string `json:"portfolio_id" validate:"required,uuid4"`
	Code          string `json:"code" validate:"required,min=2,max=50"`
	Name          string `json:"name" validate:"required,min=2,max=250"`
	ManagerUserID string `json:"manager_user_id" validate:"required,uuid4"`
	Status        string `json:"status" validate:"omitempty,oneof=draft active on_hold completed cancelled"`
}

func RegisterRoutes(secured fiber.Router) {
	group := secured.Group("/projects")
	group.Get("/", middleware.RequirePermission("project.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
	group.Get("/:id", middleware.RequirePermission("project.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"id": c.Params("id")}, nil)
	})
	group.Post("/", middleware.RequirePermission("project.create"), func(c fiber.Ctx) error {
		var req projectRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusCreated, fiber.Map{"id": uuid.NewString(), "code": req.Code}, nil)
	})
	group.Put("/:id", middleware.RequirePermission("project.update"), func(c fiber.Ctx) error {
		var req projectRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusOK, fiber.Map{"id": c.Params("id"), "code": req.Code}, nil)
	})
	group.Delete("/:id", middleware.RequirePermission("project.delete"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"archived": true, "id": c.Params("id")}, nil)
	})
}
