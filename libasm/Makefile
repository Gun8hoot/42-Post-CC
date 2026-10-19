NAME				=	libasm.a

ASM					=	nasm
ASMFLAGS			=	-f elf64

OBJECT_DIR			=	.objects

MENDATORY_SOURCES	= $(shell find srcs/mandatory -name '*.s')
ALL_SOURCES			= $(shell find srcs -name '*.s')
SRCS				= $(if $(filter bonus,$(MAKECMDGOALS)),$(ALL_SOURCES),$(MENDATORY_SOURCES))

OBJS				= $(patsubst %.s,$(OBJECT_DIR)/%.o,$(SRCS))
ALL_OBJECTS			= $(patsubst %.s,$(OBJECT_DIR)/%.o,$(ALL_SOURCES))

$(OBJECT_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	@printf "\x1b[0;32m[+] Assembling %s\x1b[0m\n" $@
	@$(ASM) $(ASMFLAGS) -o $@ $<

all: $(NAME)


bonus: $(NAME)

$(NAME): $(OBJS)
	@printf "\x1b[0;32m[+] Linking %s\n\x1b[0m" $@
	@ar rcs $@ $^

clean:
	@printf "\x1b[0;31m[+] Removing %s\x1b[0m\n" $(ALL_OBJECTS)
	@rm -f $(ALL_OBJECTS)

fclean: clean
	@printf "\x1b[0;31m[+] Removing %s\x1b[0m\n" $(NAME)
	@rm -f $(NAME)

re: fclean $(NAME)

.PHONY: all re clean fclean
