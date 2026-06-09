package integration

import (
	"net/http"
	"strings"

	"cpip/shared/config"
)

type SupabaseClient struct {
	BaseURL    string
	ServiceKey string
	Client     *http.Client
}

func NewSupabaseClient(cfg config.Config) (*SupabaseClient, bool) {
	if strings.TrimSpace(cfg.SupabaseURL) == "" || strings.TrimSpace(cfg.SupabaseServiceKey) == "" {
		return nil, false
	}
	return &SupabaseClient{
		BaseURL:    strings.TrimRight(cfg.SupabaseURL, "/"),
		ServiceKey: cfg.SupabaseServiceKey,
		Client:     &http.Client{},
	}, true
}

func (s *SupabaseClient) NewRequest(method, path string) (*http.Request, error) {
	req, err := http.NewRequest(method, s.BaseURL+path, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("apikey", s.ServiceKey)
	req.Header.Set("Authorization", "Bearer "+s.ServiceKey)
	return req, nil
}
