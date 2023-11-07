@echo off
@echo Compilando main.cpp
set flags=-std=c++14 -Wall -pedantic -pedantic-errors
g++  %flags% masino_facundo.cpp
.\a