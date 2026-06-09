package middleware

import (
	"strings"
	"time"

	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/logger"
)

func RegisterGlobal(app *fiber.App, logr *logger.Logger) {
	app.Use(requestID())
	app.Use(logging(logr))
}

func requestID() fiber.Handler {
	return func(c fiber.Ctx) error {
		reqID := c.Get("X-Request-ID")
		if reqID == "" {
			reqID = uuid.NewString()
		}
		c.Set("X-Request-ID", reqID)
		c.Locals(ContextKeyRequestID, reqID)
		return c.Next()
	}
}

func logging(logr *logger.Logger) fiber.Handler {
	return func(c fiber.Ctx) error {
		start := time.Now()
		err := c.Next()
		logr.Info("request completed", map[string]any{
			"request_id": c.Locals(ContextKeyRequestID),
			"tenant_id":  c.Locals(ContextKeyTenantID),
			"user_id":    c.Locals(ContextKeyUserID),
			"method":     c.Method(),
			"path":       c.Path(),
			"status":     c.Response().StatusCode(),
			"latency_ms": time.Since(start).Milliseconds(),
		})
		return err
	}
}

func RequireTenant() fiber.Handler {
	return func(c fiber.Ctx) error {
		tenantID := strings.TrimSpace(c.Get("X-Tenant-ID"))
		if tenantID == "" {
			return fiber.NewError(fiber.StatusBadRequest, "missing X-Tenant-ID")
		}
		c.Locals(ContextKeyTenantID, tenantID)
		return c.Next()
	}
}

func RequirePermission(permission string) fiber.Handler {
	return func(c fiber.Ctx) error {
		raw := c.Locals(ContextKeyPermission)
		perms, ok := raw.([]string)
		if !ok {
			return fiber.NewError(fiber.StatusForbidden, "forbidden")
		}
		for _, p := range perms {
			if p == permission || p == "*" {
				return c.Next()
			}
		}
		return fiber.NewError(fiber.StatusForbidden, "forbidden")
	}
}
