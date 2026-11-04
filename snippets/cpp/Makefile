#!/usr/bin/env make -S -f

# convenience functions for running the C++ project template


.PHONY: all configure build clean run test

BUILD_DIR := build


## alias to compile
all: build

## configure
configure:
	cmake -S . -B $(BUILD_DIR) -G Ninja

## compile
build: configure
	cmake --build $(BUILD_DIR)

## execute the main binary
run: build
	./$(BUILD_DIR)/my-project

## run tests
test: build
	ctest --test-dir $(BUILD_DIR) --output-on-failure

## remove compilation artifacts
clean:
	cmake --build $(BUILD_DIR) --target clean

## remove all compilation and configuration artifacts
distclean:
	rm -rf $(BUILD_DIR)
