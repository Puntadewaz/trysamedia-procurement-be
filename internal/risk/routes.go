package risk

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/middleware"
	"cpip/shared/response"
	"cpip/shared/validator"
)

type riskRequest struct {
	ProjectID   string `json:"project_id" validate:"required,uuid4"`
	Code        string `json:"code" validate:"required,min=2,max=40"`
	Title       string `json:"title" validate:"required,min=2,max=250"`
	Likelihood  int    `json:"likelihood" validate:"required,min=1,max=5"`
	Impact      int    `json:"impact" validate:"required,min=1,max=5"`
	OwnerUserID string `json:"owner_user_id" validate:"required,uuid4"`
	Status      string `json:"status" validate:"omitempty,oneof=open monitored closed"`
}

func RegisterRoutes(secured fiber.Router) {
	secured.Get("/risks", middleware.RequirePermission("risk.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
	secured.Post("/risks", middleware.RequirePermission("risk.create"), func(c fiber.Ctx) error {
		var req riskRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusCreated, fiber.Map{"id": uuid.NewString(), "code": req.Code}, nil)
	})
	secured.Put("/risks/:id", middleware.RequirePermission("risk.update"), func(c fiber.Ctx) error {
		var req riskRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusOK, fiber.Map{"id": c.Params("id"), "status": req.Status}, nil)
	})
}
