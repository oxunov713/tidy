# Local development. Variables come from .env if it exists (see .env.example).
ifneq (,$(wildcard .env))
include .env
export
endif

DATABASE_URL ?= postgres://postgres:postgres@localhost:5432/tidy?sslmode=disable
TEST_DATABASE_URL ?=

.PHONY: run test test-unit migrate seed lint fmt build docker

run: ## start the API
	go run ./cmd/api

build: ## build the API binary into bin/
	go build -o bin/api ./cmd/api

migrate: ## apply database migrations
	go run ./cmd/migrate

seed: ## create demo admin, cleaners and client
	go run ./cmd/seed

test: ## all tests; integration tests run when TEST_DATABASE_URL is set
	TEST_DATABASE_URL="$(TEST_DATABASE_URL)" go test -race -count=1 ./...

test-unit: ## tests that need no database
	TEST_DATABASE_URL= go test -race ./...

lint: ## gofmt, go vet and golangci-lint
	@test -z "$$(gofmt -l .)" || (gofmt -l . && exit 1)
	go vet ./...
	golangci-lint run ./...

fmt:
	gofmt -w .

docker: ## build the API image
	docker build -t tidy-api .
