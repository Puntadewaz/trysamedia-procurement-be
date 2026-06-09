package response

import "github.com/gofiber/fiber/v3"

type ErrorEnvelope struct {
	Success   bool           `json:"success"`
	Error     ErrorBody      `json:"error"`
	RequestID string         `json:"request_id,omitempty"`
	Meta      map[string]any `json:"meta,omitempty"`
}

type ErrorBody struct {
	Code    string `json:"code"`
	Message string `json:"message"`
}

func Success(c fiber.Ctx, status int, data any, meta map[string]any) error {
	body := fiber.Map{
		"success": true,
		"data":    data,
	}
	if meta != nil {
		body["meta"] = meta
	}
	return c.Status(status).JSON(body)
}

func Error(c fiber.Ctx, status int, code, message string) error {
	return c.Status(status).JSON(ErrorEnvelope{
		Success: false,
		Error: ErrorBody{
			Code:    code,
			Message: message,
		},
		RequestID: c.Get("X-Request-ID"),
	})
}
