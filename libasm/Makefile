NAME		=	libasm.a

AS			=	nasm
ASFLAG		=	-f elf64

OBJECT_DIR	=	.objects

SOURCES		= $(wildcard *.s */*.s */*/*.s)
OBJECTS		= $(patsubst %.s,$(OBJECT_DIR)/%.o,$(SOURCES))

$(OBJECT_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	@printf "\x1b[0;32m[+] Assembling %s\x1b[0m\n" $@
	@$(AS) $(ASFLAG) -o $@ $<

all: $(NAME)

$(NAME): $(OBJECTS)
	@printf "\x1b[0;32m[+] Linking %s\n\x1b[0m" $@

clean:
	@printf "\x1b[0;31m[+] Removing %s\x1b[0m\n" $(OBJECTS)
	@rm -f $(OBJECTS)

fclean: clean
	@printf "\x1b[0;31m[+] Removing %s\x1b[0m\n" $(NAME)
	@rm -f $(NAME)

re: fclean $(NAME)

.PHONY: $(NAME) all re clean fclaen
