package import_engine

import (
	"github.com/gofiber/fiber/v3"
	"github.com/google/uuid"

	"cpip/shared/jobs"
	"cpip/shared/middleware"
	"cpip/shared/response"
	"cpip/shared/validator"
)

type importRequest struct {
	SourceType string `json:"source_type" validate:"required,oneof=excel csv erp_export api"`
	FileRef    string `json:"file_ref" validate:"required"`
	TemplateID string `json:"template_id" validate:"required,uuid4"`
}

func RegisterRoutes(secured fiber.Router, queue jobs.Queue) {
	secured.Post("/imports", middleware.RequirePermission("import.create"), func(c fiber.Ctx) error {
		var req importRequest
		if err := c.Bind().Body(&req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", "invalid request body")
		}
		if err := validator.Struct(req); err != nil {
			return response.Error(c, fiber.StatusBadRequest, "VALIDATION_ERROR", err.Error())
		}

		tenantID, _ := c.Locals(middleware.ContextKeyTenantID).(string)
		jobID := uuid.NewString()
		_ = queue.Enqueue(jobs.Job{
			Type:     "import.parse",
			TenantID: tenantID,
			Payload: map[string]any{
				"job_id":      jobID,
				"source_type": req.SourceType,
				"file_ref":    req.FileRef,
				"template_id": req.TemplateID,
			},
		})

		return response.Success(c, fiber.StatusAccepted, fiber.Map{"job_id": jobID, "status": "queued"}, nil)
	})

	secured.Get("/imports/jobs", middleware.RequirePermission("import.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
	secured.Get("/imports/errors", middleware.RequirePermission("import.read"), func(c fiber.Ctx) error {
		return response.Success(c, fiber.StatusOK, []fiber.Map{}, fiber.Map{"next_cursor": ""})
	})
}
