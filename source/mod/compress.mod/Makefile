# Makefile.in for src/mod/compress.mod/
# $Id: Makefile.in,v 1.14 2011/07/09 15:07:48 thommey Exp $

ZLIB = 
srcdir = .


doofus:
	@echo ""
	@echo "Let's try this from the right directory..."
	@echo ""
	@cd ../../../ && make

static: ../compress.o
	@echo "$(ZLIB)" >> ../mod.xlibs

modules: ../../../compress.$(MOD_EXT)

../compress.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) -DMAKING_MODS -c $(srcdir)/compress.c
	rm -f ../compress.o
	mv compress.o ../

../../../compress.$(MOD_EXT): ../compress.o
	$(LD) -o ../../../compress.$(MOD_EXT) ../compress.o $(ZLIB) $(XLIBS) $(MODULE_XLIBS)
	$(STRIP) ../../../compress.$(MOD_EXT)

depend:
	$(CC) $(CFLAGS) -MM $(srcdir)/compress.c -MT ../compress.o > .depend

clean:
	@rm -f .depend *.o *.$(MOD_EXT) *~

distclean: clean
	@rm -f Makefile config.cache config.log config.status config.h

#safety hash
../compress.o: .././compress.mod/compress.c ../../../src/mod/module.h \
 ../../../src/main.h ../../../config.h ../../../lush.h \
 ../../../src/lang.h ../../../src/eggdrop.h ../../../src/flags.h \
 ../../../src/cmdt.h ../../../src/tclegg.h ../../../src/tclhash.h \
 ../../../src/chan.h ../../../src/users.h ../../../src/compat/compat.h \
 ../../../src/compat/inet_aton.h ../../../src/compat/snprintf.h \
 ../../../src/compat/memset.h ../../../src/compat/memcpy.h \
 ../../../src/compat/strcasecmp.h ../../../src/compat/strdup.h \
 ../../../src/compat/strftime.h ../../../src/mod/modvals.h \
 ../../../src/tandem.h ../../../src/mod/share.mod/share.h \
 .././compress.mod/compress.h .././compress.mod/tclcompress.c
