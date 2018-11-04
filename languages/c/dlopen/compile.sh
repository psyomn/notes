#!/usr/bin/env bash

CC=gcc
CFLAGS="-Wall -Werror"

$CC $CFLAGS main.c -o plugintest -ldl

$CC -fPIC -c plugin1.c -o plugin1.o
$CC -shared -o plugin1.so plugin1.o

$CC -fPIC -c plugin2.c -o plugin2.o
$CC -shared -o plugin2.so plugin2.o
