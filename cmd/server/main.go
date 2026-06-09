package main

import (
	"log"
	"strings"

	"cpip/internal/app"
)

func main() {
	runtime, err := app.Bootstrap()
	if err != nil {
		log.Fatalf("bootstrap failed: %v", err)
	}
	defer runtime.DB.Close()

	addr := runtime.Config.HTTPAddr
	runtime.Logger.Info("server starting", map[string]any{"address": addr})
	if err := runtime.App.Listen(addr); err != nil {
		if strings.Contains(err.Error(), "bind") {
			log.Fatalf(
				"server failed to bind %s (port likely in use). Stop the old process or set HTTP_ADDR=:8081. error: %v",
				addr,
				err,
			)
		}
		log.Fatalf("server failed: %v", err)
	}
}
