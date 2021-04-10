rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
SOURCES=$(call rwildcard,src,*.asm)
DEST=gsc

$(DEST): $(SOURCES)
	sjasmplus src/main.asm

clean:
	rm $(DEST)