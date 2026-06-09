package handler

import (
	"net/http"
	"sync"

	"cpip/internal/app"
)

var (
	once       sync.Once
	httpHandle http.Handler
	bootErr    error
)

func Handler(w http.ResponseWriter, r *http.Request) {
	once.Do(func() {
		rt, err := app.Bootstrap()
		if err != nil {
			bootErr = err
			return
		}
		httpHandle = rt.App.Handler()
	})

	if bootErr != nil {
		http.Error(w, "bootstrap failed: "+bootErr.Error(), http.StatusInternalServerError)
		return
	}
	httpHandle.ServeHTTP(w, r)
}
