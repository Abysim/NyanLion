# Makefile for src/mod/megahal.mod/

doofus:
	@echo ""
	@echo "Let's try this from the right directory..."
	@echo ""
	@cd ../../../; make

static: ../megahal.o

modules: ../../../megahal.$(MOD_EXT)

../megahal.o: ../module.h ../modvals.h ../../eggdrop.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -DMAKING_MODS -c $(srcdir)/megahal.c
	rm -f ../megahal.o
	mv megahal.o ../

../../../megahal.$(MOD_EXT): ../megahal.o
	$(LD) -o ../../../megahal.$(MOD_EXT) ../megahal.o $(XLIBS)
	$(STRIP) ../../../megahal.$(MOD_EXT)

depend:
	$(CC) $(CFLAGS) $(CPPFLAGS) -MM $(srcdir)/megahal.c > .depend

clean:
	@rm -f .depend *.o *.$(MOD_EXT) *~

#safety hash


../megahal.o: .././megahal.mod/megahal.c .././megahal.mod/megahal.h \
 ../../../src/mod/module.h ../../../config.h ../../../src/main.h \
 ../../..//src/lang.h ../../../src/eggdrop.h ../../../src/flags.h \
 ../../../src/proto.h ../../../lush.h ../../../src/cmdt.h \
 ../../../src/tclegg.h ../../../src/tclhash.h ../../../src/chan.h \
 ../../../src/users.h ../../../src/mod/modvals.h ../../../src/tandem.h
