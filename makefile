BUILDDIR=bin

compile:
	mkdir -p $(BUILDDIR)
	nim c --outdir:bin src/pwGenerator.nim
