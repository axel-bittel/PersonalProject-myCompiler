# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: abittel <abittel@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/06/22 22:59:14 by rahmed            #+#    #+#              #
#    Updated: 2023/02/03 16:35:06 by abittel          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #




SRC_DIR			=	./src
INC_DIR			=	./includes
CC				=	gcc
RM				=	rm -f
AR				=	ar rcs
ASM				= 	as

UNAME_S			:=	$(shell uname -s)

CFLAGS			=	-g 
PARSER_FILE		=	${SRC_DIR}/parser.y
LEXER_FILE		=	${SRC_DIR}/lexer.l
SRCS			=	${SRC_DIR}/ft_tree/ft_treeadd_f.c\
					${SRC_DIR}/ft_tree/ft_treenew.c\
					${SRC_DIR}/ft_tree/ft_treeprof.c\
					${SRC_DIR}/ast.c\
					${SRC_DIR}/symbol_table.c
PARSER			= 	./y.tab.c

ifeq ($(HOSTTYPE),)
	HOSTTYPE := $(shell uname -m)_$(shell uname -s)
endif

NAME			=	compiler

HEADER		=	-I${INC_DIR} -I${INC_DIR}/ft_tree -I./
LDFLAGS		=	-L${SRC_DIR}
FSFLAGS		=	#-fsanitize=address

OBJS				=	${SRCS:.c=.o}
OPARSER_GEN_FILE	=	${PARSER:.c=.o}
%.o				:	%.c
					@echo "${TXT_BLUE}"
					@echo "~~~~~~~ MAKE PROJECT ~~~~~~~~"
					${CC} -c ${CFLAGS} ${FSFLAGS} -o $@ $< ${HEADER} 
					@echo "${FANCY_RESET}"

${NAME}			:	lexer parser ${OPARSER_GEN_FILE} ${OBJS}
					@echo "${TXT_YELLOW}"
					@echo "~~~~~~~ COMPILATION ~~~~~~~~~"
					@echo "${TXT_GREEN}"
					${CC} ${LDFLAGS} ${CFLAGS} ${FSFLAGS} -o ${NAME} ${OBJS} ${OPARSER_GEN_FILE}
					@echo "${FANCY_RESET}"

all			:	${NAME} 

lexer		:	
				lex ${LEXER_FILE}
parser		:	
				yacc ${PARSER_FILE}

clean :
				@echo "${TXT_YELLOW}"
				@echo "~~~~~~~~~~ CLEAN ~~~~~~~~~~~~"
				@echo "${TXT_RED}"
				${RM}  ${OBJS} ./lex.yy.c ./y.tab.c ./y.tab.o
				@echo "$(FANCY_RESET)"

fclean		:	clean
				@echo "${TXT_YELLOW}"
				@echo "~~~~~~~~~~ FCLEAN ~~~~~~~~~~"
				@echo "${TXT_MAGENTA}"
				${RM} ${NAME}
				${RM} ${NAME_FINAL}
				@echo "$(FANCY_RESET)"

re			:	fclean all

.PHONY		:	all clean fclean re
############### PARTIE TEST ###############
test		:
				make
				@echo "${TXT_YELLOW}"
				@echo "\n~~~~~~~~~~   CPP   ~~~~~~~~~~~"
				@echo "${FANCY_RESET}"
				./${NAME} ${ARG}

norm		:
				@echo "${TXT_YELLOW}"
				@echo "\n~~~~~ CHECK PROJECT NORM ~~~~~~~"
				@echo "${TXT_CYAN}"
				norminette ${SRC_DIR}/*.c -R CheckForbiddenSourceHeader
				@echo "${TXT_GREEN}"
				norminette ${INC_DIR}/*.h -R CheckDefine
				@echo "${FANCY_RESET}"

flush		:	fclean
				@echo "${TXT_YELLOW}"
				@echo "\n~~~~~~~ Extra-CLEANING  ~~~~~~~~"
				@echo "${TXT_RED}"
				${RM} .DS_STORE
				${RM} *.out
				${RM} *.a
				${RM} ${SRC_DIR}/*.o
				${RM} -R *.dSYM
				@echo "${FANCY_RESET}"

# Set COLORS
TXT_RED		=	\033[1;31m
TXT_GREEN	=	\033[1;32m
TXT_YELLOW	=	\033[1;33m
TXT_BLUE	=	\033[1;34m
TXT_MAGENTA	=	\033[1;35m
TXT_CYAN	=	\033[1;36m
BCK_RED		=	\033[0;41m
BCK_GREEN	=	\033[0;42m
BCK_YELLOW	=	\033[0;43m
BCK_BLUE	=	\033[0;44m
BCK_MAGENTA	=	\033[0;45m
BCK_CYAN	=	\033[0;46m
FANCY_RESET	=	\033[0m
###########################################
