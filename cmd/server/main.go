package main

import (
	"log"
	"net/http"
	"strings"

	"github.com/gofiber/fiber/v3/middleware/adaptor"

	"cpip/pkg/app"
	"cpip/shared/config"
)

func main() {
	runtime, err := app.Bootstrap()
	if err != nil {
		log.Fatalf("bootstrap failed: %v", err)
	}
	if runtime.DB != nil {
		defer runtime.DB.Close()
	}

	addr := config.ResolveHTTPAddr()
	runtime.Logger.Info("server starting", map[string]any{
		"address": addr,
		"runtime": "net/http",
	})

	// Vercel Go runtime health-checks net/http listening on PORT.
	handler := adaptor.FiberApp(runtime.App)
	if err := http.ListenAndServe(addr, handler); err != nil {
		if strings.Contains(err.Error(), "bind") {
			log.Fatalf(
				"server failed to bind %s. On Vercel remove HTTP_ADDR and rely on PORT. error: %v",
				addr,
				err,
			)
		}
		log.Fatalf("server failed: %v", err)
	}
}
