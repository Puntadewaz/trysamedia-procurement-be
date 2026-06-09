package logger

import (
	"encoding/json"
	"log"
	"os"
	"time"
)

type Logger struct {
	base *log.Logger
}

func New() *Logger {
	return &Logger{base: log.New(os.Stdout, "", 0)}
}

func (l *Logger) Info(message string, fields map[string]any) {
	l.log("INFO", message, fields)
}

func (l *Logger) Error(message string, fields map[string]any) {
	l.log("ERROR", message, fields)
}

func (l *Logger) log(level, message string, fields map[string]any) {
	entry := map[string]any{
		"timestamp": time.Now().UTC().Format(time.RFC3339Nano),
		"level":     level,
		"message":   message,
	}
	for k, v := range fields {
		entry[k] = v
	}

	blob, err := json.Marshal(entry)
	if err != nil {
		l.base.Printf(`{"level":"ERROR","message":"failed to marshal log","error":"%v"}`, err)
		return
	}
	l.base.Println(string(blob))
}
