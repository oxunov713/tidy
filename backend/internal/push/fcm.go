package push

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"

	"github.com/oxunov713/tidy/backend/internal/domain"
)

const fcmScope = "https://www.googleapis.com/auth/firebase.messaging"

// FCM sends notifications through the Firebase Cloud Messaging HTTP v1 API.
type FCM struct {
	client   *http.Client
	endpoint string
}

// NewFCM builds a sender from the contents of a service account JSON file.
func NewFCM(ctx context.Context, serviceAccountJSON []byte) (*FCM, error) {
	var sa struct {
		ProjectID string `json:"project_id"`
	}
	if err := json.Unmarshal(serviceAccountJSON, &sa); err != nil || sa.ProjectID == "" {
		return nil, fmt.Errorf("fcm: service account JSON without project_id")
	}
	creds, err := google.CredentialsFromJSON(ctx, serviceAccountJSON, fcmScope)
	if err != nil {
		return nil, fmt.Errorf("fcm: %w", err)
	}
	return &FCM{
		client:   oauth2.NewClient(ctx, creds.TokenSource),
		endpoint: "https://fcm.googleapis.com/v1/projects/" + sa.ProjectID + "/messages:send",
	}, nil
}

type fcmMessage struct {
	Message struct {
		Token        string            `json:"token"`
		Notification fcmNotification   `json:"notification"`
		Data         map[string]string `json:"data,omitempty"`
	} `json:"message"`
}

type fcmNotification struct {
	Title string `json:"title"`
	Body  string `json:"body"`
}

func (f *FCM) Send(ctx context.Context, token string, n domain.Notification) error {
	var msg fcmMessage
	msg.Message.Token = token
	msg.Message.Notification = fcmNotification{Title: n.Title, Body: n.Body}
	msg.Message.Data = n.Data
	body, err := json.Marshal(msg)
	if err != nil {
		return err
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, f.endpoint, bytes.NewReader(body))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")
	resp, err := f.client.Do(req)
	if err != nil {
		return fmt.Errorf("fcm: %w", err)
	}
	defer resp.Body.Close()

	switch resp.StatusCode {
	case http.StatusOK:
		return nil
	// FCM answers 404 UNREGISTERED once the app is uninstalled.
	case http.StatusNotFound:
		return domain.ErrDeviceTokenGone
	default:
		detail, _ := io.ReadAll(io.LimitReader(resp.Body, 1024))
		return fmt.Errorf("fcm: %s: %s", resp.Status, bytes.TrimSpace(detail))
	}
}
