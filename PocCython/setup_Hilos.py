# Archivo compilación Cython

from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("PoC_Cython_Hilos.pyx"),
)
