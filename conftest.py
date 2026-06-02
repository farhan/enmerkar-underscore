"""
Ensure pkg_resources is importable before any tests run.

enmerkar 0.7.1 does `from pkg_resources import get_distribution` in its
__init__.py. pkg_resources ships with setuptools, but in some virtualenv
configurations setuptools is installed without pkg_resources being
importable. This shim falls back to importlib.metadata when needed.
"""
import sys

try:
    import pkg_resources  # noqa: F401
except ImportError:
    import importlib.metadata
    import types

    _mod = types.ModuleType("pkg_resources")

    class _Dist:
        def __init__(self, dist):
            self._dist = dist

        @property
        def version(self):
            return self._dist.metadata["Version"]

        def __str__(self):
            return self._dist.metadata["Name"]

    def _get_distribution(name):
        return _Dist(importlib.metadata.distribution(name))

    _mod.get_distribution = _get_distribution
    sys.modules["pkg_resources"] = _mod
