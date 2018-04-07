#!/usr/bin/env bash

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
(cd "$THIS_DIR" && docker build -t cryolite/gcc:latest .)
