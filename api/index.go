package handler

import (
	"net/http"
	"sync"

	"github.com/gofiber/fiber/v3/middleware/adaptor"

	"cpip/pkg/app"
)

var (
	once       sync.Once
	httpHandle http.HandlerFunc
	bootErr    error
)

// Handler is the Vercel serverless entry point.
func Handler(w http.ResponseWriter, r *http.Request) {
	// Required so Fiber receives the correct path from net/http.
	r.RequestURI = r.URL.String()

	once.Do(func() {
		rt, err := app.Bootstrap()
		if err != nil {
			bootErr = err
			return
		}
		httpHandle = adaptor.FiberApp(rt.App)
	})

	if bootErr != nil {
		http.Error(w, "bootstrap failed: "+bootErr.Error(), http.StatusInternalServerError)
		return
	}
	httpHandle.ServeHTTP(w, r)
}
