package jobs

import (
	"sync"

	"cpip/shared/logger"
)

type Job struct {
	Type     string
	TenantID string
	Payload  map[string]any
}

type Queue interface {
	Enqueue(job Job) error
}

type InMemoryQueue struct {
	mu   sync.Mutex
	jobs []Job
	log  *logger.Logger
}

func NewInMemoryQueue(logr *logger.Logger) *InMemoryQueue {
	return &InMemoryQueue{log: logr}
}

func (q *InMemoryQueue) Enqueue(job Job) error {
	q.mu.Lock()
	defer q.mu.Unlock()
	q.jobs = append(q.jobs, job)
	q.log.Info("job enqueued", map[string]any{
		"type":      job.Type,
		"tenant_id": job.TenantID,
	})
	return nil
}
