#!/usr/bin/env bash

CC=gcc
CFLAGS="-Wall -Werror"

$CC $CFLAGS main.c -o plugintest -ldl

$CC -fPIC -c plugin.c -o plugin.o
$CC -shared -o plugin.so plugin.o
