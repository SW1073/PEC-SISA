.RECIPEPREFIX = >
CC=gcc
CFLAGS=-Wall

all: gen

%: %.c
> $(CC) $(CFLAGS) $^ -o $@

run: gen
> ./gen

clean:
> rm gen
