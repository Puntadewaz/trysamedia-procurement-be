package middleware

import (
	"errors"

	"github.com/gofiber/fiber/v3"

	"cpip/shared/response"
)

func ErrorHandler(c fiber.Ctx, err error) error {
	if err == nil {
		return nil
	}
	var fe *fiber.Error
	if errors.As(err, &fe) {
		return response.Error(c, fe.Code, "HTTP_ERROR", fe.Message)
	}
	return response.Error(c, fiber.StatusInternalServerError, "INTERNAL_ERROR", "internal server error")
}
