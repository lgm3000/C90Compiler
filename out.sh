#!/bin/bash

cat tests/a1.c | bin/c_codegen > tests/a1.s
cat tests/a2.c | bin/c_codegen > tests/a2.s
cat tests/a3.c | bin/c_codegen > tests/a3.s
cat tests/a4.c | bin/c_codegen > tests/a4.s
cat tests/a5.c | bin/c_codegen > tests/a5.s
