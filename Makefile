.POSIX:
CC       = cc
CFLAGS   = -std=c99 -Wall -Wextra -Wno-missing-field-initializers -Os
CPPFLAGS =
LDFLAGS  = -ggdb3
LDLIBS   =
PREFIX   = /usr/local
BINDIR   = $(PREFIX)/bin
MANDIR   = $(PREFIX)/share/man

all: endlessh

endlessh: endlessh.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ endlessh.c $(LDLIBS)

install: endlessh
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 endlessh $(DESTDIR)$(BINDIR)/
	install -d $(DESTDIR)$(MANDIR)/man1
	install -m 644 endlessh.1 $(DESTDIR)$(MANDIR)/man1/

clean:
	rm -rf endlessh

docker:
	docker build . -t endlessh

docker-routeros:
	@echo "Building Docker image for RouterOS on arm64"
	@docker buildx build --no-cache --platform=linux/arm64 -t endlessh -f Dockerfile.routeros.arm64 .
	@echo "Saving Docker image to endlessh-routeros-arm64.tgz"
	@docker save endlessh | gzip > endlessh-routeros-arm64.tgz
	@echo "Cleaning up after build"
	@docker buildx prune -f

run:
	docker run --rm -it --init endlessh
