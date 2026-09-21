# Build dir, src dir, name
NAME      := main
BUILD_DIR := build
SRC_DIR   := src

# Compiler
CC      := gcc
AR      := gcc-ar
CFLAGS  := -std=c23 -Wall -Wextra -O2 -flto -MMD -MP
LDFLAGS := -flto

# Mode
MODE := exe

# Main and src
MAIN_SRC ?= main.c
MAIN_OBJ := $(BUILD_DIR)/$(notdir $(MAIN_SRC:.c=.o))

SRCS := $(shell find $(SRC_DIR) -name '*.c')
OBJS   := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d) $(MAIN_OBJ:.o=.d)

# Lib and exe (.so, .a, exe)
LIB_A  := $(BUILD_DIR)/lib$(NAME).a
LIB_SO := $(BUILD_DIR)/lib$(NAME).so
EXE    := $(BUILD_DIR)/$(NAME)

all: $(MODE)

exe:    $(EXE)
lib_a:  $(LIB_A)
lib_so: $(LIB_SO)

$(EXE): $(MAIN_OBJ) $(LIB_A) | $(BUILD_DIR)
	$(CC) $(MAIN_OBJ) $(LIB_A) $(LDFLAGS) -o $@

$(LIB_A): $(OBJS) | $(BUILD_DIR)
	$(AR) rcs $@ $(OBJS)

$(LIB_SO): $(OBJS) | $(BUILD_DIR)
	$(CC) -shared $(OBJS) $(LDFLAGS) -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -fPIC -c $< -o $@

$(MAIN_OBJ): $(MAIN_SRC) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $@

-include $(DEPS)

run: $(EXE)
	./$(EXE)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all exe lib_a lib_so run clean
