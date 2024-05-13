.RECIPEPREFIX = >
CC=gcc
CFLAGS=-Wall

all: gen

gen: gen.c instruction.h instruction.c
> $(CC) $(CFLAGS) $^ -o $@

run: gen
> ./gen

clean:
> rm gen
