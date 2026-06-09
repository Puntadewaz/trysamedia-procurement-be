package pagination

import (
	"encoding/base64"
	"encoding/json"
)

type Cursor struct {
	ID        string `json:"id"`
	CreatedAt string `json:"created_at"`
}

func Encode(c Cursor) (string, error) {
	b, err := json.Marshal(c)
	if err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(b), nil
}

func Decode(raw string) (Cursor, error) {
	var c Cursor
	b, err := base64.RawURLEncoding.DecodeString(raw)
	if err != nil {
		return c, err
	}
	if err := json.Unmarshal(b, &c); err != nil {
		return c, err
	}
	return c, nil
}
