NAME		=	libasm.a

CC			=	gcc
CFLAGS		=	-g3 -c -I.

AS			=	nasm
ASFLAG		=	-f elf64

OBJECT_DIR	=	.objects

SOURCES		= $(wildcard *.s */*.s */*/*.s)
OBJECTS		= $(patsubst %.s,$(OBJECT_DIR)/%.o,$(SOURCES))

CSOURCES	= $(wildcard *.c */*.c */*/*.c)
COBJECTS	= $(patsubst %.c,$(OBJECT_DIR)/%.o,$(CSOURCES))

# ASSEMBLING .s FILES
$(OBJECT_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	@printf "\x1b[0;32m[+] Assembling %s\x1b[0m\n" $@
	@$(AS) $(ASFLAG) -o $@ $<

# COMPILING .c FILES
$(OBJECT_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	@printf "\x1b[0;32m[+] Compiling %s\x1b[0m\n" $@
	@$(CC) $(CFLAGS) -o $@ $<

all: $(NAME)

$(NAME): $(OBJECTS)
	@printf "\x1b[0;32m[+] Linking %s\n\x1b[0m" $@

clean:
	@printf "\x1b[0;31m[+] Removing %s\x1b[0m\n" $(OBJECTS)
	@rm -f $(OBJECTS)

fclean: clean
	@printf "\x1b[0;31m[+] Removing %s\x1b[0m\n" $(NAME)
	@rm -f $(NAME)
	@rm -f $(tester)

re: fclean $(NAME)

tester: $(OBJECTS) $(COBJECTS)
	@printf "\x1b[0;32m[+] Linking %s\n\x1b[0m" $@
	@$(CC) $(OBJECTS) $(COBJECTS) -o $@

.PHONY: $(NAME) all re clean fclaen
