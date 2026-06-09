package middleware

import (
	"strings"

	"github.com/gofiber/fiber/v3"

	"cpip/shared/auth"
)

func RequireJWT(secret string) fiber.Handler {
	return func(c fiber.Ctx) error {
		authHeader := c.Get("Authorization")
		if authHeader == "" {
			return fiber.NewError(fiber.StatusUnauthorized, "missing authorization header")
		}
		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) != 2 || !strings.EqualFold(parts[0], "Bearer") {
			return fiber.NewError(fiber.StatusUnauthorized, "invalid authorization header")
		}

		claims, err := auth.ParseAccessToken(secret, parts[1])
		if err != nil {
			return fiber.NewError(fiber.StatusUnauthorized, "invalid token")
		}

		c.Locals(ContextKeyUserID, claims.UserID)
		c.Locals(ContextKeyTenantID, claims.TenantID)
		c.Locals(ContextKeyPermission, claims.Permissions)
		return c.Next()
	}
}
