NAME				=	libasm.a

ASM					=	nasm
ASMFLAGS			=	-f elf64

OBJECT_DIR			=	.objects

MENDATORY_SOURCES	= $(shell find srcs/mandatory -name '*.s')
ALL_SOURCES			= $(shell find srcs -name '*.s')

MENDATORY_OBJECTS	= $(patsubst %.s,$(OBJECT_DIR)/%.o,$(MENDATORY_SOURCES))
ALL_OBJECTS			= $(patsubst %.s,$(OBJECT_DIR)/%.o,$(ALL_SOURCES))

# ASSEMBLING .s FILES
$(OBJECT_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	@printf "\x1b[0;32m[+] Assembling %s\x1b[0m\n" $@
	@$(ASM) $(ASMFLAGS) -o $@ $<

all: $(NAME)

$(NAME): $(MENDATORY_OBJECTS)
	@printf "\x1b[0;32m[+] Linking %s\n\x1b[0m" $@
	@ar rcs $@ $(MENDATORY_OBJECTS)

bonus: $(ALL_OBJECTS)
	@printf "\x1b[0;32m[+] Linking %s\n\x1b[0m" $(NAME)		# RELINKING RULE
	@ar rcs $(NAME) $(ALL_OBJECTS)

clean:
	@printf "\x1b[0;31m[+] Removing %s\x1b[0m\n" $(ALL_OBJECTS)
	@rm -f $(ALL_OBJECTS)

fclean: clean
	@printf "\x1b[0;31m[+] Removing %s\x1b[0m\n" $(NAME)
	@rm -f $(NAME)

re: fclean $(NAME)

.PHONY: all re clean fclean
