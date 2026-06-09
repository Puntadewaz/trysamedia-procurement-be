package portfolio

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/middleware"
	"cpip/shared/response"
	"cpip/shared/validator"
)

type portfolioRequest struct {
	Code        string `json:"code" validate:"required,min=2,max=40"`
	Name        string `json:"name" validate:"required,min=2,max=200"`
	OwnerUserID string `json:"owner_user_id" validate:"required,uuid4"`
	Status      string `json:"status" validate:"omitempty,oneof=active inactive archived"`
}

func RegisterRoutes(secured fiber.Router) {
	group := secured.Group("/portfolios")
	group.Get("/", middleware.RequirePermission("portfolio.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
	group.Get("/:id", middleware.RequirePermission("portfolio.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"id": c.Params("id")}, nil)
	})
	group.Post("/", middleware.RequirePermission("portfolio.create"), func(c fiber.Ctx) error {
		var req portfolioRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusCreated, fiber.Map{"id": uuid.NewString(), "code": req.Code}, nil)
	})
	group.Put("/:id", middleware.RequirePermission("portfolio.update"), func(c fiber.Ctx) error {
		var req portfolioRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusOK, fiber.Map{"id": c.Params("id"), "code": req.Code}, nil)
	})
}
