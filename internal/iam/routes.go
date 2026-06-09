package iam

import (
	"time"

	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/auth"
	"cpip/shared/config"
	"cpip/shared/middleware"
	"cpip/shared/response"
	"cpip/shared/validator"
)

type loginRequest struct {
	Email      string `json:"email" validate:"required,email"`
	Password   string `json:"password" validate:"required,min=8"`
	TenantCode string `json:"tenant_code" validate:"required"`
}

type refreshRequest struct {
	RefreshToken string `json:"refresh_token" validate:"required"`
}

type mfaVerifyRequest struct {
	ChallengeID string `json:"challenge_id" validate:"required"`
	TOTPCode    string `json:"totp_code" validate:"required,len=6,numeric"`
}

type upsertUserRequest struct {
	Email   string   `json:"email" validate:"omitempty,email"`
	Name    string   `json:"name" validate:"required,min=2,max=150"`
	Password string  `json:"password" validate:"omitempty,min=8"`
	Status  string   `json:"status" validate:"omitempty,oneof=active inactive suspended"`
	RoleIDs []string `json:"role_ids"`
}

func RegisterAuthRoutes(v1 fiber.Router, cfg config.Config) {
	authGroup := v1.Group("/auth")
	authGroup.Post("/login", func(c fiber.Ctx) error {
		var req loginRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}

		// Placeholder authentication flow for scaffold; replace with repository-backed login.
		token, err := auth.GenerateAccessToken(cfg.JWTAccessSecret, cfg.JWTIssuer, cfg.JWTAudience, auth.Claims{
			UserID:      uuid.NewString(),
			TenantID:    uuid.NewString(),
			Permissions: []string{"*"},
		})
		if err != nil {
			return response.Error(c, fiber.StatusInternalServerError, "TOKEN_ISSUE_ERROR", "failed to issue token")
		}

		return response.Success(c, fiber.StatusOK, fiber.Map{
			"access_token":  token,
			"refresh_token": uuid.NewString(),
			"expires_in":    int64((15 * time.Minute).Seconds()),
			"mfa_required":  false,
		}, nil)
	})

	authGroup.Post("/refresh", func(c fiber.Ctx) error {
		var req refreshRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusOK, fiber.Map{
			"access_token":  uuid.NewString(),
			"refresh_token": uuid.NewString(),
		}, nil)
	})

	authGroup.Post("/logout", func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"logged_out": true}, nil)
	})

	authGroup.Post("/mfa/verify", func(c fiber.Ctx) error {
		var req mfaVerifyRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusOK, fiber.Map{"verified": true}, nil)
	})
}

func RegisterUserRoutes(secured fiber.Router) {
	users := secured.Group("/users")

	users.Get("/", middleware.RequirePermission("iam.user.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
	users.Get("/:id", middleware.RequirePermission("iam.user.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"id": c.Params("id")}, nil)
	})
	users.Post("/", middleware.RequirePermission("iam.user.create"), func(c fiber.Ctx) error {
		var req upsertUserRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusCreated, fiber.Map{"id": uuid.NewString(), "name": req.Name}, nil)
	})
	users.Put("/:id", middleware.RequirePermission("iam.user.update"), func(c fiber.Ctx) error {
		var req upsertUserRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}
		return response.Success(c, fiber.StatusOK, fiber.Map{"id": c.Params("id"), "name": req.Name}, nil)
	})
	users.Delete("/:id", middleware.RequirePermission("iam.user.delete"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, fiber.Map{"deleted": true, "id": c.Params("id")}, nil)
	})
}
