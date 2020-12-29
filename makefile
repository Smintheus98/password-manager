CC=nim
SRCDIR=src
OUTDIR=bin

build:
	mkdir -p $(OUTDIR)
	$(CC) c --outdir:$(OUTDIR) $(SRCDIR)/main.nim

generator:
	mkdir -p $(OUTDIR)
	$(CC) c --outdir:$(OUTDIR) $(SRCDIR)/pwGenerator.nim
