.PHONY: clean-pyc clean-build docs clean upgrade

help:
	@echo "clean-build - remove build artifacts"
	@echo "clean-pyc - remove Python file artifacts"
	@echo "quality - check style with flake8"
	@echo "test - run tests quickly with the default Python"
	@echo "test-all - run tests on every Python version with tox"
	@echo "docs - generate Sphinx HTML documentation, including API docs"
	@echo "upgrade - update the pip requirements files to use the latest releases satisfying our constraints"

clean: clean-build clean-pyc
	rm -fr htmlcov/

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +

quality:
	uv run tox -e quality

test:
	uv run tox -e py312-django52

test-all:
	uv run tox

docs:
	uv run tox -e docs

requirements:
	uv sync --group dev
	uv tool install tox --with tox-uv

upgrade:
	uv run --with edx-lint edx_lint write_uv_constraints pyproject.toml
	uv lock --upgrade
