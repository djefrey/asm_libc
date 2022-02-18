##
## EPITECH PROJECT, 2022
## B-ASM-400-STG-4-1-asmminilibc-jeffrey.winkler
## File description:
## Makefile
##

SRC				=	src/start.asm			\
					src/string.asm			\
					src/memory.asm

OBJ				=	$(SRC:%.asm=%.o)

NAME			=	libasm.so

%.o: %.asm
	nasm -f elf64 $< -o $@

all: $(NAME)

$(NAME): $(OBJ)
	gcc -shared -o $(NAME) $(OBJ)

clean:
	rm -f $(OBJ)

fclean: clean
	rm -f $(NAME)

re: fclean all