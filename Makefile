.PHONY: all
all: lint/ruff lint

help:
	@adt help-make


#
# Lint
#
.PHONY: lint/ruff lint udit

##
lint/ruff:
	ruff check src

## Lint source code and check typing
lint:
	ruff check src
	# flake8 src
	# lint-imports
	# deptry src
	vulture --min-confidence 80 src
	mypy --show-error-codes src
	pyright src

## Run security audit
audit:
	pip-audit
	safety check

#
# Rest
#
.PHONY: develop run run-gunicorn clean tidy format cleanup-code

## Setup the development environment
develop:
	poetry install
	flask vite install

## Run (dev) server
run:
	honcho -f Procfile.dev start

## Run server under gunicorn
run-gunicorn:
	gunicorn -b 127.0.0.1:5000 -w1 'app:app'

## Cleanup repository
clean:
	adt clean
	rm -rf .mypy_cache .pytest_cache .ruff_cache .import_linter_cache .hypothesis
	rm -f log/*
	rm -f geckodriver.log
	rm -rf .grimp_cache
	find . -name __pycache__ -print0 | xargs -0 rm -rf
	rm -rf .tox .nox

## Cleanup harder
tidy: clean
	rm -rf vite/dist
	rm -rf vite/node_modules

## Format source code
format:
	black src
	isort src

.PHONY: build
build:
	flask vite build
