package validator

import (
	"errors"

	"github.com/go-playground/validator/v10"
)

var validate = validator.New()

func Struct(v any) error {
	if err := validate.Struct(v); err != nil {
		return errors.New("validation failed")
	}
	return nil
}
