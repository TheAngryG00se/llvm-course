CC      := clang
SRC_DIR := scr
IR_DIR  := ir

SRCS := $(wildcard $(SRC_DIR)/*.c)
IRS  := $(patsubst $(SRC_DIR)/%.c,$(IR_DIR)/%.ll,$(SRCS))

OPT_select   := -O1
OPT_tailcall := -O2

.PHONY: all clean

all: $(IRS)

$(IR_DIR)/%.ll: $(SRC_DIR)/%.c | $(IR_DIR)
	$(CC) -S -emit-llvm $(if $(OPT_$*),$(OPT_$*),-O0) -o $@ $<

$(IR_DIR):
	mkdir -p $(IR_DIR)

clean:
	rm -f $(IR_DIR)/*.ll
