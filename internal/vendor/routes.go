package vendor

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/middleware"
	"cpip/shared/response"
	"cpip/shared/validator"
)

type vendorRequest struct {
	Code     string `json:"code" validate:"required,min=2,max=40"`
	Name     string `json:"name" validate:"required,min=2,max=200"`
	Category string `json:"category" validate:"required,min=2,max=80"`
	Status   string `json:"status" validate:"omitempty,oneof=active inactive suspended"`
}

func RegisterRoutes(secured fiber.Router) {
	secured.Get("/vendors", middleware.RequirePermission("vendor.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
	secured.Post("/vendors", middleware.RequirePermission("vendor.create"), func(c fiber.Ctx) error {
		var req vendorRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusCreated, fiber.Map{"id": uuid.NewString(), "code": req.Code}, nil)
	})
	secured.Get("/vendors/:id", middleware.RequirePermission("vendor.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"id": c.Params("id")}, nil)
	})
}
