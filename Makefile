DEBUG = FALSE
GCC = nspire-gcc
AS = nspire-as
GXX=nspire-g++
LD = nspire-ld
GENZEHN = genzehn
#-bflt
GCCFLAGS = -Wall -W -marm -Werror=missing-prototypes -Werror=missing-declarations -Werror=implicit-function-declaration
LDFLAGS = -L. -lvpx
ifeq ($(DEBUG),FALSE)
	GCCFLAGS += -O3
else
	GCCFLAGS += -Og -g
	LDFLAGS += --debug
endif
EXE = nvid
OBJS = $(patsubst %.c,%.o,$(wildcard *.c))
DISTDIR = .
vpath %.tns $(DISTDIR)

all: $(EXE).tns

%.o: %.c
	$(GCC) $(GCCFLAGS) -c $<

$(EXE).elf: $(OBJS)
	mkdir -p $(DISTDIR)
	$(LD) $^ -o $(DISTDIR)/$@ $(LDFLAGS)
	
$(EXE).tns: $(EXE).elf
	$(GENZEHN) --input $^ --output $@.zehn $(ZEHNFLAGS)
	make-prg $@.zehn $@
	rm $@.zehn

clean:
	rm -f *.o *.elf *.gdb
	rm -f $(DISTDIR)/$(EXE)
