/*
 * 11Dec2007 Buster 
 * 05Dec2007 Buster 
 * 03May2004 vd (Vladimir Degtyarenko) 
 * 11Apr2003 vd (Vladimir Degtyarenko)
 * 14Sep2002 vd (Vladimir Degtyarenko)
 * Minor changes to make it work with Russian symbols
 * 
 * 13Apr2002 vd (Vladimir Degtyarenko)
 * alt'nicks, +(-)nopubmega on chanel
 *
 * 07Jun2001 vd (Vladimir Degtyarenko)
 * Changes to make it work with Russian symbols on eggdrop1.6.x
 */
/*
 * minor changes to make it work on eggdrop1.4 (guppy 27Jan2000)
 */
/*===========================================================================*/
/*
 *  Original Copyright (C) 1998/1999 Jason Hutchens
 *  Copyright (C) 2000 Steve Huston
 *
 *  This program is free software; you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License as published by the Free
 *  Software Foundation; either version 2 of the license or (at your option)
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful, but
 *  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 *  or FITNESS FOR A PARTICULAR PURPOSE.  See the Gnu Public License for more
 *  details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  675 Mass Ave, Cambridge, MA 02139, USA.
 */
/*===========================================================================*/

/*
 *		Please note, that I don't know much about licensing and legalities.  So
 *		far as I know, what I'm doing is fine; but if someone cares to point out
 *		my shortsightedness, feel free :P
 *
 *		This is a minor rewrite of the original megahal.c and megahal.h files
 *		to compile them in as a module for Eggdrop.  Guarantees: None,
 *		Warranties: none, etc.  Use at your own risk, if it makes your hdd
 *		become possessed, I don't care, yadda yadda yadda.  I'm not big on
 *		comments, but I'll try to note where changes were made.  In order to
 *		keep this as simple as possible, I'm leaving all previous comments and
 *		remarks in the code.
 *
 *		        Steve Huston (huston@elvis.rowan.edu)
 */

/*
 *		$Id: megahal.c,v 1.25 1999/10/21 03:42:48 hutch Exp hutch $
 *
 *		File:			megahal.c
 *
 *		Program:		MegaHAL v8r6
 *
 *		Purpose:		To simulate a natural language conversation with a psychotic
 *						computer.  This is achieved by learning from the user's
 *						input using a third-order Markov model on the word level.
 *						Words are considered to be sequences of characters separated
 *						by whitespace and punctuation.  Replies are generated
 *						randomly based on a keyword, and they are scored using
 *						measures of surprise.
 *
 *		Author:		Mr. Jason L. Hutchens
 *
 *		WWW:			http://ciips.ee.uwa.edu.au/~hutch/hal/
 *
 *		E-Mail:		hutch@ciips.ee.uwa.edu.au
 *
 *		Contact:		The Centre for Intelligent Information Processing Systems
 *						Department of Electrical and Electronic Engineering
 *						The University of Western Australia
 *						AUSTRALIA 6907
 *
 *		Phone:		+61-8-9380-3856
 *
 *		Facsimile:	+61-8-9380-1168
 *
 *		Notes:		- This file is best viewed with tabstops set to three spaces.
 *						- To the Debian guys, yes, it's only one file, so shoot me!
 *						  I had to get it to work on DOS with crappy compilers and
 *						  I didn't want to spend more time than was neccessary.
 *						  Hence it's rather monolithic.  Also, an email would be
 *						  appreciated whenever bugs were fixed/discovered.  I've
 *						  terminated all of the memory leakage bugs AFAICT.  But
 *						  it does allocate a helluva lot of memory, I'll admit!
 *
 *		Compilation Notes
 *		=================
 *
 *		When compiling, be sure to link with the maths library so that the
 *		log() function can be found.
 *
 *		On the Macintosh, add the library SpeechLib to your project.  It is
 *		very important that you set the attributes to Import Weak.  You can
 *		do this by selecting the lib and then use Project Inspector from the
 *		Window menu.
 *
 *		CREDITS
 *		=======
 *
 *		Amiga (AmigaOS)
 *		---------------
 *		Dag Agren (dagren@ra.abo.fi)
 *
 *		DEC (OSF)
 *		---------
 *		Jason Hutchens (hutch@ciips.ee.uwa.edu.au)
 *
 *		Macintosh
 *		---------
 *		Paul Baxter (pbaxter@assistivetech.com)
 *		Doug Turner (dturner@best.com)
 *
 *		PC (Linux - Debian package)
 *		---------------------------
 *		Joey Hess (joeyh@master.debian.org)
 *
 *		PC (OS/2)
 *		---------
 *		Bjorn Karlowsky (?)
 *
 *		PC (Windows 3.11)
 *		-----------------
 *		Jim Crawford (pfister_@hotmail.com)
 *
 *		PC (Windows '95)
 *		----------------
 *		Jason Hutchens (hutch@ciips.ee.uwa.edu.au)
 *
 *		PPC (Linux)
 *		-----------
 *		Lucas Vergnettes (Lucasv@sdf.lonestar.org)
 *
 *		SGI (Irix)
 *		----------
 *		Jason Hutchens (hutch@ciips.ee.uwa.edu.au)
 *
 *		Sun (SunOS)
 *		-----------
 *		Jason Hutchens (hutch@ciips.ee.uwa.edu.au)
 */
/*===========================================================================*/
#define MAKING_MEGAHAL
#define MODULE_NAME "megahal"
#define MODULE_VERSION "changes on 11Dec2007"
#include <errno.h>
#include "../module.h"
#include "../channels.mod/channels.h"
#include <stdlib.h>
/* megahal preproc directives */
#include <stdio.h>
#include <stdarg.h>
/* #include <malloc.h> */
#include <string.h>
#include <signal.h>
#include <time.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/stat.h> 
#include <math.h>
/* End megahal preproc directives */
#include "megahal.h"

#undef global

/* extern char		 botnetnick[]; */

/*
 * This might be ugly, but here's the predefinitiions of the functions in the
 * code for MegaHAL... they were at the top of megahal.c, so they're here too.
 * Maybe someday I'll clean this up and remove the ones not needed.
 */

static void add_aux(MODEL *, DICTIONARY *, STRING);
static void add_key(MODEL *, DICTIONARY *, STRING);
static void add_node(TREE *, TREE *, int);
static void add_swap(SWAP *, unsigned char *, unsigned char *);
static TREE *add_symbol(TREE *, BYTE2);
static BYTE2 add_word(DICTIONARY *, STRING);
static int babble(MODEL *, DICTIONARY *, DICTIONARY *);
static bool boundary(unsigned char *, int);
static void capitalize(unsigned char *);
static void change_personality(DICTIONARY *, int, MODEL **);
static void change_think(DICTIONARY *, int);
static bool dissimilar(DICTIONARY *, DICTIONARY *);
static void error(char *, char *, ...);
static float evaluate_reply(MODEL *, DICTIONARY *, DICTIONARY *);
static TREE *find_symbol(TREE *, int);
static TREE *find_symbol_add(TREE *, int);
static BYTE2 find_word(DICTIONARY *, STRING);
static unsigned char *format_output(char *);
static void free_dictionary(DICTIONARY *);
static void free_model(MODEL *);
static void free_tree(TREE *);
static void free_word(STRING);
static void free_words(DICTIONARY *);
static void free_swap(SWAP *);
static unsigned char *generate_reply(MODEL *, DICTIONARY *);
static void initialize_context(MODEL *);
static void initialize_dictionary(DICTIONARY *);
static DICTIONARY *initialize_list(char *);
static SWAP *initialize_swap(char *);
static void learn(MODEL *, DICTIONARY *);
static void load_dictionary(FILE *, DICTIONARY *);
static bool load_model(char *, MODEL *);
static void load_personality(MODEL **);
static void load_tree(FILE *, TREE *);
static void load_word(FILE *, DICTIONARY *);
static DICTIONARY *make_keywords(MODEL *, DICTIONARY *);
static unsigned char *make_output(DICTIONARY *);
static void make_words(unsigned char *, DICTIONARY *);
static DICTIONARY *new_dictionary(void);
static MODEL *new_model(int);
static TREE *new_node(void);
static SWAP *new_swap(void);
static DICTIONARY *reply(MODEL *, DICTIONARY *);
static void save_dictionary(FILE *, DICTIONARY *);
static void save_model(char *, MODEL *);
static void save_tree(FILE *, TREE *);
static void save_word(FILE *, STRING);
static int search_dictionary(DICTIONARY *, STRING, bool *);
static int search_node(TREE *, int, bool *);
static int seed(MODEL *, DICTIONARY *);
static void show_dictionary(DICTIONARY *);
static bool status(char *, ...);
static void train(MODEL *, char *);
static void update_context(MODEL *, int);
static void update_model(MODEL *, int);
static void upper(unsigned char *);
static bool warn(char *, char *, ...);
static int wordcmp(STRING, STRING);
static bool word_exists(DICTIONARY *, STRING);
static int rnd(int);
static int width=75;
static int order=5;
static int timeout=2;
static bool prog=TRUE;
static DICTIONARY *ban=NULL;
static DICTIONARY *aux=NULL;
static SWAP *swp=NULL;
static bool used_key;
static char *directory=NULL;
static char *last=NULL;
/* end predefinitions */

/*  vd  */
#define MAXOUTPUT 4096
#define MAXOUTPUTSYMBOLS 2048

static unsigned char megpatch[255] = ".";
static unsigned char megfileprefix[120] = "megahal";
static char charspaces[]= " !.?,:;()/_#-[]\042\140\134*+=<>\047@{}";
static int globsize;

static bool egisalnum( unsigned char);
static bool egisalpha( unsigned char);
static unsigned char egupper(unsigned char);
static unsigned char eglower(unsigned char);

static void unload_personality(MODEL **);
static void free_alldic(void);

static void save_msg(MODEL *);
static void msgsave_tree(FILE *, TREE *);
static void msg_makeoutput(char *, int *, BYTE2);
static void msg_cleartreeusage(TREE *);
static void msg_restoretreeusage(TREE *);

static int expmem_model(void);
static int expmem_tree(TREE *);
static int expmem_dictionary(DICTIONARY *);
static int expmem_swap(SWAP *);
static void appendload(MODEL **);
static FILE *openfile(char *, char *);

/* end vd  */

/*
 * Herein lies the code kluge of the century.. and it's only January :P  This
 * is the beginning of some hacking to keep functions happy.  I'm sure that
 * it's ugly, but it should work.  Yes, you guessed it: Global variables.
 * Only way (I think) that MegaHAL can keep track of its personality, as well
 * as what it currently knows.  These were defined in main() before, but in
 * here there is no main, so....
 */
static DICTIONARY *words=NULL; 
static MODEL *model=NULL;
static int position=0;

static Function *global = NULL;
/* static Function *irc_funcs = NULL; */
/* static Function *server_funcs = NULL; */
static Function *channels_funcs = NULL;

static int megahal_expmem()
{
  int size = 0;

  Context;
  globsize = 0;
  size += expmem_model();
  size += expmem_dictionary(ban);
  size += expmem_dictionary(aux);
  size += expmem_swap(swp);

  return size;
}

/*
 * Next, a hacked attempt at strdup(), since I can't use malloc() anywhere.
 */

static unsigned char *mystrdup(const unsigned char *s) {
	unsigned char *mytmp = nmalloc(strlen(s)+1);
	if (mytmp==NULL) return NULL;
	else strcpy(mytmp, s);

	return mytmp;
}

static int tcl_learn STDVAR
{
	char *text;
	
	BADARGS(2, 2, " text");
	
	text = argv[1];

	/* Is there anything to parse? */
	if (!text[0]) {
		return TCL_OK;
	}
	
	Context;
	strip_mirc_codes(STRIP_BOLD | STRIP_REV | STRIP_UNDER | STRIP_COLOR, text);
	
	Context;
	upper(text);
	Context;
	make_words(text, words);
	Context;
	learn(model, words);
	Context;
	
	return TCL_OK;
}

static int tcl_getreply STDVAR
{
	char *halreply;

	BADARGS(2, 2, " text");

	upper(argv[1]);
	make_words(argv[1], words);
	halreply = generate_reply(model, words);
	capitalize(halreply);
	Tcl_SetObjResult(irp, Tcl_NewStringObj(halreply, -1));

	return TCL_OK;
}

static int tcl_brainsave STDVAR
{
	Context;
	save_model(".brn", model);
	save_msg(model);

	return TCL_OK;
}

static int tcl_brainreload STDVAR
{
	Context;
	change_personality(NULL, 0, &model);

	return TCL_OK;
}

static int tcl_brainappendload STDVAR
{
	Context;
	appendload(&model);

	return TCL_OK;
}

static int dcc_save_brain(struct userrec *u, int idx, char *par)
{
	Context;
	putlog(LOG_MISC, "*", "Brain saved by %s", dcc[idx].nick);
	save_model(".brn", model);
	save_msg(model);
	return 0;
}
static int dcc_reload_brain(struct userrec *u, int idx, char *par)
{
	Context;
	putlog(LOG_MISC, "*", "Brain reload by %s", dcc[idx].nick);
	change_personality(NULL, 0, &model);
	return 0;
}
static int dcc_appendload_brain(struct userrec *u, int idx, char *par)
{
	Context;
	putlog(LOG_MISC, "*", "Brain appendload by %s", dcc[idx].nick);
	appendload(&model);
	return 0;
}

static cmd_t mega_dcc[] =
{
  {"brainsave", "n", dcc_save_brain, NULL},
  {"brainreload", "n", dcc_reload_brain, NULL},
  {"brainappendload", "n", dcc_appendload_brain, NULL},
  {NULL, NULL, NULL, NULL},
};

static tcl_strings my_tcl_strings[] =
{
  {"meg_patch", megpatch, 255, 0},
  {"meg_file_prefix", megfileprefix, 120, 0},
  {0, 0, 0, 0}
};

static tcl_cmds mega_cmds[] =
{
  {"learn",	tcl_learn},
  {"getreply",	tcl_getreply},
  {"brainsave",	tcl_brainsave},
  {"brainreload",	tcl_brainreload},
  {"brainappendload",	tcl_brainappendload},
  {NULL,	NULL}
};

/* a report on the module status */
static void megahal_report(int idx, int details)
{
  int size;

  Context;
  size = megahal_expmem();

  if (details) {
/*
    dprintf(idx, "    Original Copyright (C) 1998/1999 Jason Hutchens \"hutch\"\n");
    dprintf(idx, "    Copyright (C) 2000 Steve Huston\n");
    dprintf(idx, "    Copyright (C) 2001/2004 Vladimir Degtyarenko \"vd\"\n");
 */
    dprintf(idx, "    Buster last %s\n", MODULE_VERSION);
    dprintf(idx, "    Memory usage  : %d bytes\n", size);
    dprintf(idx, "    Unique words  : %d\n", model->forward->branch);
    dprintf(idx, "    Total words   : %d\n", model->forward->usage);
    dprintf(idx, "    Total messages: %d\n", model->forward->tree[0]->count);
    dprintf(idx, "    Dictionaries: .aux %d; .ban %d; .swp %d\n",aux->size,ban->size,swp->size);
    dprintf(idx, "  megahal dcc commands:\n");
    dprintf(idx, "    .brainsave\n");
    dprintf(idx, "    .brainreload\n");
    dprintf(idx, "    .brainappendload\n");
  }
}

static char *megahal_close()
{
	unload_personality(&model);
	rem_builtins(H_dcc, mega_dcc);
	rem_tcl_commands(mega_cmds);
	rem_tcl_strings(my_tcl_strings);
	module_undepend(MODULE_NAME);
	return NULL;
}

#if defined (__CYGWIN__) && !defined(STATIC)
__declspec(dllexport) char * __cdecl megahal_start();
#else
char *megahal_start();
#endif

static Function megahal_table[] =
{
  (Function) megahal_start,
  (Function) megahal_close,
  (Function) megahal_expmem,
  (Function) megahal_report,
};

char *megahal_start(Function * global_funcs)
{
	register int i;
	global = global_funcs;
	Context;
	module_register(MODULE_NAME, megahal_table, 3, 01);
	if (!(channels_funcs = module_depend(MODULE_NAME, "channels", 1, 0)))
		return "You need the channels module to use the stats module.";
	add_tcl_commands(mega_cmds);
	add_tcl_strings(my_tcl_strings);

	add_builtins(H_dcc, mega_dcc);
	words=new_dictionary();

	/*
	 * Load the default personality.
	 */
	Context;
	change_personality(NULL, 0, &model);
	Context;

	putlog(LOG_MISC, "*", "::megahal:: megahal.mod %s loaded.", MODULE_VERSION);

	return NULL;
}

/*
 * The remainder of this code was just pasted from the rest of megahal.c, and
 * modified where necessary to get messages put in the right place, etc.
 */

/*---------------------------------------------------------------------------*/
/*
 *		Function:	Error
 *
 *		Purpose:		Print the specified message to the error file.
 */
static void error(char *title, char *fmt, ...)
{
	va_list argp;
	char stuff[512];

	putlog(LOG_MISC, "*","::megahal:: Error from \"%s\":", title);

	va_start(argp, fmt);
	vsprintf(stuff, fmt, argp);
	va_end(argp);

	putlog(LOG_MISC, "*", "    %s", stuff);

}

/*---------------------------------------------------------------------------*/

static bool warn(char *title, char *fmt, ...)
{
	va_list argp;
	unsigned char stuff[512];

	putlog(LOG_MISC, "*","::megahal:: Warning from \"%s\":", title);

	va_start(argp, fmt);
	vsprintf(stuff, fmt, argp);
	va_end(argp);        
                              
	putlog(LOG_MISC, "*", "    %s", stuff);
	return(TRUE);
}
/*---------------------------------------------------------------------------*/
/*
 *		Function:egisalnum
 */
static bool egisalnum( unsigned char c)
{
    int rsm = c;
#if defined (CP1251)
    if(((rsm>0x40)&&(rsm<0x5b))		\
	||((rsm>0x60)&&(rsm<0x7b))	\
	||((rsm>0xbf)&&(rsm<=0xff))	\
	||((rsm>=0x30)&&(rsm<=0x39))	\
	||(rsm==0xa5)			\
	||(rsm==0xaa)			\
	||(rsm==0xaf)			\
	||(rsm==0xb2)			\
	||(rsm==0xb3)			\
	||(rsm==0xb4)			\
	||(rsm==0xba)			\
	||(rsm==0xbf)			\
	||(rsm==0xa8)			\
	||(rsm==0xb8))		 	\
	return(TRUE);
#else
    if(((rsm>0x40)&&(rsm<0x5b))		\
	||((rsm>0x60)&&(rsm<0x7b))	\
	||((rsm>0xbf)&&(rsm<=0xff))	\
	||((rsm>=0x30)&&(rsm<=0x39))	\
	||(rsm==0xa3)			\
	||(rsm==0xb3)) 			\
	return(TRUE); 
#endif
    return(FALSE);
}
/*---------------------------------------------------------------------------*/
/*
 *		Function:	egisalpha
 *
 *		Purpose:	Convert a char to its uppercase representation.
 */
static bool egisalpha( unsigned char c)
{
    int rsm = c;
#if defined (CP1251)
    if(((rsm>0x40)&&(rsm<0x5b))		\
	||((rsm>0x60)&&(rsm<0x7b))	\
	||((rsm>0xbf)&&(rsm<=0xff))	\
	||(rsm==0xa5)			\
	||(rsm==0xaa)			\
	||(rsm==0xaf)			\
	||(rsm==0xb2)			\
	||(rsm==0xb3)			\
	||(rsm==0xb4)			\
	||(rsm==0xba)			\
	||(rsm==0xbf)			\
	||(rsm==0xa8)			\
	||(rsm==0xb8)) 			\
	return(TRUE); 
#else
    if(((rsm>0x40)&&(rsm<0x5b))		\
	||((rsm>0x60)&&(rsm<0x7b))	\
	||((rsm>0xbf)&&(rsm<=0xff))	\
	||(rsm==0xa3)			\
	||(rsm==0xb3))			\
	return(TRUE); 
#endif
    return(FALSE);
}
/*---------------------------------------------------------------------------*/

/*
 *		Function:	egUpper
 *
 *		Purpose:	Convert a char to its uppercase representation.
 */
static unsigned char egupper(unsigned char rsm)
{
   if((rsm>0x60)&&(rsm<0x7b)) return(rsm-32);
#if defined (CP1251)
   if((rsm>0xdf)&&(rsm<=0xff)) return(rsm-32);
   if(rsm==0xb8) return(rsm-16);
   if(rsm==0xba) return(rsm-16);
   if(rsm==0xbf) return(rsm-16); 
   if(rsm==0xb4) return(rsm-15); 
   if(rsm==0xb3) return(rsm-1);  
#else
   if((rsm>0xbf)&&(rsm<0xe0)) return(rsm+32); 
   if(rsm==0xa3) return(rsm+16); 
#endif
   return(rsm);
}
/*---------------------------------------------------------------------------*/

/*
 *		Function:	eglower
 *
 *		Purpose:	Convert a char to its lowercase representation.
 */
static unsigned char eglower(unsigned char rsm)
{
	if((rsm>0x40)&&(rsm<0x5b)) return(rsm+32);
#if defined (CP1251)
	if((rsm>0xbf)&&(rsm<0xe0)) return(rsm+32);
	if(rsm==0xa8) return(rsm+16);
	if(rsm==0xaa) return(rsm+16);
	if(rsm==0xaf) return(rsm+16);
	if(rsm==0xa5) return(rsm+15);
	if(rsm==0xb2) return(rsm+1);
#else
        if((rsm>0xdf)&&(rsm<=0xff)) return(rsm-32); 
        if(rsm==0xb3) return(rsm-16); 
#endif
        return(rsm);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Capitalize
 *
 *		Purpose:		Convert a string to look nice.
 */
static void capitalize(unsigned char *string)
{
	register int i;
	bool start=TRUE;

	for(i=0; i<(int)strlen(string); ++i) {
		if(egisalpha((unsigned char)string[i])) {
			if(start==TRUE) string[i]=egupper((unsigned char)string[i]);
			else string[i]=eglower((unsigned char)string[i]);
			start=FALSE;
		}
		if((i>2)&&(strchr("!.?", string[i-1])!=NULL)&&(isspace(string[i])))
			start=TRUE;
	}
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Upper
 *
 *		Purpose:		Convert a string to its uppercase representation.
 */
static void upper(unsigned char *string)
{
	register int i;
	register int j=0;
	int s=1;

	for(i=0; i<(int)strlen(string); ++i) {
	  if(string[i]=='\t') string[i]='\040';
	  string[j]=(unsigned char)egupper((unsigned char)string[i]);
   	    if((unsigned char)string[i]=='\040') ++s;
	    else s=0;
	    if(s<2) ++j;
	}
	string[j]='\0';
	if((j>2)&&((string[j-2]=='\015')||(string[j-2]=='\040'))) string[j-2]='\0';
	if((j>2)&&((string[j-1]=='\015')||(string[j-1]=='\040'))) string[j-1]='\0';
}
/*---------------------------------------------------------------------------*/

/*
 *		Function:	Add_Word
 *
 *		Purpose:		Add a word to a dictionary, and return the identifier
 *						assigned to the word.  If the word already exists in
 *						the dictionary, then return its current identifier
 *						without adding it again.
 */
static BYTE2 add_word(DICTIONARY *dictionary, STRING word)
{
	register int i;
	int position;
	bool found;

	/*
	 *		If the word's already in the dictionary, there is no need to add it
	 */
	position=search_dictionary(dictionary, word, &found);
	if(found==TRUE) goto succeed;

	/*
	 *		Increase the number of words in the dictionary
	 */
	dictionary->size+=1;

	/*
	 *		Allocate one more entry for the word index
	 */
	if(dictionary->index==NULL) {
		dictionary->index=(BYTE2 *)nmalloc(sizeof(BYTE2)*
		(dictionary->size));
	} else {
		dictionary->index=(BYTE2 *)nrealloc((BYTE2 *)
		(dictionary->index),sizeof(BYTE2)*(dictionary->size));
	}
	if(dictionary->index==NULL) {
		error("add_word", "Unable to nreallocate the index.");
		goto fail;
	}

	/*
	 *		Allocate one more entry for the word array
	 */
	if(dictionary->entry==NULL) {
		dictionary->entry=(STRING *)nmalloc(sizeof(STRING)*(dictionary->size));
	} else {
		dictionary->entry=(STRING *)nrealloc((STRING *)(dictionary->entry),
		sizeof(STRING)*(dictionary->size));
	}
	if(dictionary->entry==NULL) {
		error("add_word", "Unable to nreallocate the dictionary to %d elements.", dictionary->size);
		goto fail;
	}

	/*
	 *		Copy the new word into the word array
	 */
	dictionary->entry[dictionary->size-1].length=word.length;
	dictionary->entry[dictionary->size-1].word=(char *)nmalloc(sizeof(char)*
	(word.length));
	if(dictionary->entry[dictionary->size-1].word==NULL) {
		error("add_word", "Unable to allocate the word.");
		goto fail;
	}
	for(i=0; i<word.length; ++i)
		dictionary->entry[dictionary->size-1].word[i]=word.word[i];

	/*
	 *		Shuffle the word index to keep it sorted alphabetically
	 */
	for(i=(dictionary->size-1); i>position; --i)
		dictionary->index[i]=dictionary->index[i-1];

	/*
	 *		Copy the new symbol identifier into the word index
	 */
	dictionary->index[position]=dictionary->size-1;

succeed:
	return(dictionary->index[position]);

fail:
	return(0);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Search_Dictionary
 *
 *		Purpose:		Search the dictionary for the specified word, returning its
 *						position in the index if found, or the position where it
 *						should be inserted otherwise.
 */
static int search_dictionary(DICTIONARY *dictionary, STRING word, bool *find)
{
	int position;
	int min;
	int max;
	int middle;
	int compar;

	/*
	 *		If the dictionary is empty, then obviously the word won't be found
	 */
	if(dictionary->size==0) {
		position=0;
		goto notfound;
	}

	/*
	 *		Initialize the lower and upper bounds of the search
	 */
	min=0;
	max=dictionary->size-1;
	/*
	 *		Search repeatedly, halving the search space each time, until either
	 *		the entry is found, or the search space becomes empty
	 */
	while(TRUE) {
		/*
		 *		See whether the middle element of the search space is greater
		 *		than, equal to, or less than the element being searched for.
		 */
		middle=(min+max)/2;
		compar=wordcmp(word, dictionary->entry[dictionary->index[middle]]);
		/*
		 *		If it is equal then we have found the element.  Otherwise we
		 *		can halve the search space accordingly.
		 */
		if(compar==0) {
			position=middle;
			goto found;
		} else if(compar>0) {
			if(max==middle) {
				position=middle+1;
				goto notfound;
			}
			min=middle+1;
		} else {
			if(min==middle) {
				position=middle;
				goto notfound;
			}
			max=middle-1;
		}
	}

found:
	*find=TRUE;
	return(position);

notfound:
	*find=FALSE;
	return(position);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Find_Word
 *
 *		Purpose:		Return the symbol corresponding to the word specified.
 *						We assume that the word with index zero is equal to a
 *						NULL word, indicating an error condition.
 */
static BYTE2 find_word(DICTIONARY *dictionary, STRING word)
{
	int position;
	bool found;

	position=search_dictionary(dictionary, word, &found);

	if(found==TRUE) return(dictionary->index[position]);
	else return(0);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Wordcmp
 *
 *		Purpose:		Compare two words, and return an integer indicating whether
 *						the first word is less than, equal to or greater than the
 *						second word.
 */
static int wordcmp(STRING word1, STRING word2)
{
	register int i;
	int bound;

	bound=MIN(word1.length,word2.length);

	for(i=0; i<bound; ++i)
		if(egupper((unsigned char)word1.word[i])!=egupper((unsigned char)word2.word[i]))
			return((int)(egupper((unsigned char)word1.word[i])-egupper((unsigned char)word2.word[i])));

	if(word1.length<word2.length) return(-1);
	if(word1.length>word2.length) return(1);


	return(0);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Free_Dictionary
 *
 *		Purpose:		Release the memory consumed by the dictionary.
 */
static void free_dictionary(DICTIONARY *dictionary)
{
	if(dictionary==NULL) return;
	if(dictionary->entry!=NULL) {
		nfree(dictionary->entry);
		dictionary->entry=NULL;
	}
	if(dictionary->index!=NULL) {
		nfree(dictionary->index);
		dictionary->index=NULL;
	}
	dictionary->size=0;
}

/*---------------------------------------------------------------------------*/

static void free_model(MODEL *model)
{
	if(model==NULL) return;
	if(model->forward!=NULL) {
		free_tree(model->forward);
                model->forward=NULL;
	}
	if(model->backward!=NULL) {
		free_tree(model->backward);
                model->backward=NULL;
	}
	if(model->halcontext!=NULL) {
		nfree(model->halcontext);
                model->halcontext=NULL;
	}
	if(model->dictionary!=NULL) {
		free_words(model->dictionary);
		free_dictionary(model->dictionary);
		nfree(model->dictionary);
                model->dictionary=NULL;
	}
	nfree(model);
	model=NULL;  
}

/*---------------------------------------------------------------------------*/

static void free_tree(TREE *tree)
{
	static int level=0;
	register int i;

	if(tree==NULL) return;

	if(tree->tree!=NULL) {
		for(i=0; i<tree->branch; ++i) {
			++level;
			free_tree(tree->tree[i]);
			--level;
		}
		nfree(tree->tree);
/* vd */
		tree->tree=NULL;
	}
	nfree(tree);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Initialize_Dictionary
 *
 *		Purpose:		Add dummy words to the dictionary.
 */
static void initialize_dictionary(DICTIONARY *dictionary)
{
	STRING word={ 7, "<ERROR>" };
	STRING end={ 5, "<FIN>" };

	(void)add_word(dictionary, word);
	(void)add_word(dictionary, end);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	New_Dictionary
 *
 *		Purpose:		Allocate room for a new dictionary.
 */
static DICTIONARY *new_dictionary(void)
{
	DICTIONARY *dictionary=NULL;

	dictionary=(DICTIONARY *)nmalloc(sizeof(DICTIONARY));
	if(dictionary==NULL) {
		error("new_dictionary", "Unable to allocate dictionary.");
		return(NULL);
	}

	dictionary->size=0;
	dictionary->index=NULL;
	dictionary->entry=NULL;

	return(dictionary);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Save_Dictionary
 *
 *		Purpose:		Save a dictionary to the specified file.
 */
static void save_dictionary(FILE *file, DICTIONARY *dictionary)
{
	register int i;

	fwrite(&(dictionary->size), sizeof(BYTE4), 1, file);
	for(i=0; i<dictionary->size; ++i) {
		save_word(file, dictionary->entry[i]);
	}
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Load_Dictionary
 *
 *		Purpose:		Load a dictionary from the specified file.
 */
static void load_dictionary(FILE *file, DICTIONARY *dictionary)
{
	register int i;
	int size;

	fread(&size, sizeof(BYTE4), 1, file);
	for(i=0; i<size; ++i) {
		load_word(file, dictionary);
	}
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Save_Word
 *
 *		Purpose:		Save a dictionary word to a file.
 */
static void save_word(FILE *file, STRING word)
{
	register int i;

	fwrite(&(word.length), sizeof(BYTE1), 1, file);
	for(i=0; i<word.length; ++i)
		fwrite(&(word.word[i]), sizeof(char), 1, file);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Load_Word
 *
 *		Purpose:		Load a dictionary word from a file.
 */
static void load_word(FILE *file, DICTIONARY *dictionary)
{
	register int i;
	STRING word;

	fread(&(word.length), sizeof(BYTE1), 1, file);
	word.word=(char *)nmalloc(sizeof(char)*word.length);
	if(word.word==NULL) {
		error("load_word", "Unable to allocate word");
		return;
	}
	for(i=0; i<word.length; ++i)
		fread(&(word.word[i]), sizeof(char), 1, file);
	add_word(dictionary, word);
	nfree(word.word);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	New_Node
 *
 *		Purpose:		Allocate a new node for the n-gram tree, and initialise
 *						its contents to sensible values.
 */
static TREE *new_node(void)
{
	TREE *node=NULL;

	/*
	 *		Allocate memory for the new node
	 */
	node=(TREE *)nmalloc(sizeof(TREE));
	if(node==NULL) {
		error("new_node", "Unable to allocate the node.");
		goto fail;
	}

	/*
	 *		Initialise the contents of the node
	 */
	node->symbol=0;
	node->usage=0;
	node->count=0;
	node->branch=0;
	node->tree=NULL;

	return(node);

fail:
	if(node!=NULL) nfree(node);
	return(NULL);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	New_Model
 *
 *		Purpose:		Create and initialise a new ngram model.
 */
static MODEL *new_model(int order)
{
	MODEL *model=NULL;

	model=(MODEL *)nmalloc(sizeof(MODEL));
	if(model==NULL) {
		error("new_model", "Unable to allocate model.");
		goto fail;
	}

	model->order=order;
	model->forward=new_node();
	model->backward=new_node();
	model->halcontext=(TREE **)nmalloc(sizeof(TREE *)*(order+2));
	if(model->halcontext==NULL) {
		error("new_model", "Unable to allocate context array.");
		goto fail;
	}
	initialize_context(model);
	model->dictionary=new_dictionary();
	initialize_dictionary(model->dictionary);

	return(model);

fail:
	return(NULL);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Update_Model
 *
 *		Purpose:		Update the model with the specified symbol.
 */
static void update_model(MODEL *model, int symbol)
{
	register int i;

	/*
	 *		Update all of the models in the current context with the specified
	 *		symbol.
	 */
	for(i=(model->order+1); i>0; --i)
		if(model->halcontext[i-1]!=NULL)
			model->halcontext[i]=add_symbol(model->halcontext[i-1], (BYTE2)symbol);

	return;
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Update_Context
 *
 *		Purpose:		Update the context of the model without adding the symbol.
 */
static void update_context(MODEL *model, int symbol)
{
	register int i;

	for(i=(model->order+1); i>0; --i)
		if(model->halcontext[i-1]!=NULL)
			model->halcontext[i]=find_symbol(model->halcontext[i-1], symbol);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Add_Symbol
 *
 *		Purpose:		Update the statistics of the specified tree with the
 *						specified symbol, which may mean growing the tree if the
 *						symbol hasn't been seen in this context before.
 */
static TREE *add_symbol(TREE *tree, BYTE2 symbol)
{
	TREE *node=NULL;

	/*
	 *		Search for the symbol in the subtree of the tree node.
	 */
	node=find_symbol_add(tree, symbol);

	/*
	 *		Increment the symbol counts
	 */
	if((node->count<65535)) {
		node->count+=1;
		tree->usage+=1;
	}

	return(node);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Find_Symbol
 *
 *		Purpose:		Return a pointer to the child node, if one exists, which
 *						contains the specified symbol.
 */
static TREE *find_symbol(TREE *node, int symbol)
{
	register int i;
	TREE *found=NULL;
	bool found_symbol=FALSE;

	/*
	 *		Perform a binary search for the symbol.
	 */
	i=search_node(node, symbol, &found_symbol);
	if(found_symbol==TRUE) found=node->tree[i];

	return(found);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Find_Symbol_Add
 *
 *		Purpose:		This function is conceptually similar to find_symbol,
 *						apart from the fact that if the symbol is not found,
 *						a new node is automatically allocated and added to the
 *						tree.
 */
static TREE *find_symbol_add(TREE *node, int symbol)
{
	register int i;
	TREE *found=NULL;
	bool found_symbol=FALSE;

	/*
	 *		Perform a binary search for the symbol.  If the symbol isn't found,
	 *		attach a new sub-node to the tree node so that it remains sorted.
	 */
	i=search_node(node, symbol, &found_symbol);
	if(found_symbol==TRUE) {
		found=node->tree[i];
	} else {
		found=new_node();
		found->symbol=symbol;
		add_node(node, found, i);
	}

	return(found);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Add_Node
 *
 *		Purpose:		Attach a new child node to the sub-tree of the tree
 *						specified.
 */
static void add_node(TREE *tree, TREE *node, int position)
{
	register int i;

	/*
	 *		Allocate room for one more child node, which may mean allocating
	 *		the sub-tree from scratch.
	 */
	if(tree->tree==NULL) {
		tree->tree=(TREE **)nmalloc(sizeof(TREE *)*(tree->branch+1));
	} else {
		tree->tree=(TREE **)nrealloc((TREE **)(tree->tree),sizeof(TREE *)*
		(tree->branch+1));
	}
	if(tree->tree==NULL) {
		error("add_node", "Unable to nreallocate subtree.");
		return;
	}

	/*
	 *		Shuffle the nodes down so that we can insert the new node at the
	 *		subtree index given by position.
	 */
	for(i=tree->branch; i>position; --i)
		tree->tree[i]=tree->tree[i-1];

	/*
	 *		Add the new node to the sub-tree.
	 */
	tree->tree[position]=node;
	tree->branch+=1;
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Search_Node
 *
 *		Purpose:		Perform a binary search for the specified symbol on the
 *						subtree of the given node.  Return the position of the
 *						child node in the subtree if the symbol was found, or the
 *						position where it should be inserted to keep the subtree
 *						sorted if it wasn't.
 */
static int search_node(TREE *node, int symbol, bool *found_symbol)
{
	register int position;
	int min;
	int max;
	int middle;
	int compar;

	/*
	 *		Handle the special case where the subtree is empty.
	 */
	if(node->branch==0) {
		position=0;
		goto notfound;
	}

	/*
	 *		Perform a binary search on the subtree.
	 */
	min=0;
	max=node->branch-1;
	while(TRUE) {
		middle=(min+max)/2;
		compar=symbol-node->tree[middle]->symbol;
		if(compar==0) {
			position=middle;
			goto found;
		} else if(compar>0) {
			if(max==middle) {
				position=middle+1;
				goto notfound;
			}
			min=middle+1;
		} else {
			if(min==middle) {
				position=middle;
				goto notfound;
			}
			max=middle-1;
		}
	}

found:
	*found_symbol=TRUE;
	return(position);

notfound:
	*found_symbol=FALSE;
	return(position);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Initialize_Context
 *
 *		Purpose:		Set the context of the model to a default value.
 */
static void initialize_context(MODEL *model)
{
	register int i;

	for(i=0; i<=model->order; ++i) model->halcontext[i]=NULL;
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Learn
 *
 *		Purpose:		Learn from the user's input.
 */
static void learn(MODEL *model, DICTIONARY *words)
{
	register int i;
	BYTE2 symbol;

	/*
	 *		We only learn from inputs which are long enough
	 */
	if(words->size<=(model->order)) {
	  if(words->size<3) return;
	  while(words->size<=(model->order)) {
	    if(words->entry==NULL)
		words->entry=(STRING *)nmalloc((words->size+1)*sizeof(STRING));
	    else
		words->entry=(STRING *)nrealloc(words->entry, (words->size+1)*sizeof(STRING));

	    if(words->entry==NULL) {
		error("learn", "Unable to reallocate dictionary");
		return;
	    }
	    words->entry[words->size].length=1;
	    words->entry[words->size].word="\t";
	    words->size+=1;
	  }	
	}

	/*
	 *		Train the model in the forwards direction.  Start by initializing
	 *		the context of the model.
	 */
	initialize_context(model);
	model->halcontext[0]=model->forward;
	for(i=0; i<words->size; ++i) {
		/*
		 *		Add the symbol to the model's dictionary if necessary, and then
		 *		update the forward model accordingly.
		 */
		symbol=add_word(model->dictionary, words->entry[i]);
		update_model(model, symbol);
	}
	/*
	 *		Add the sentence-terminating symbol.
	 */
	update_model(model, 1);

	/*
	 *		Train the model in the backwards direction.  Start by initializing
	 *		the context of the model.
	 */
	initialize_context(model);
	model->halcontext[0]=model->backward;
	for(i=words->size-1; i>=0; --i) {
		/*
		 *		Find the symbol in the model's dictionary, and then update
		 *		the backward model accordingly.
		 */
		symbol=find_word(model->dictionary, words->entry[i]);
		update_model(model, symbol);
	}
	/*
	 *		Add the sentence-terminating symbol.
	 */
	update_model(model, 1);

	return;
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Train
 *
 *		Purpose:	 	Infer a MegaHAL brain from the contents of a text file.
 */
static void train(MODEL *model, char *filename)
{
	FILE *file;
	unsigned char buffer[1024];
	DICTIONARY *words=NULL;
	int length;

	if(filename==NULL) return;

	file=openfile(filename, "r");
	if(file==NULL) {
		putlog(LOG_MISC, "*", "Unable to find the personality \"%s%s%s%s\"\n", directory, SEP, megfileprefix, filename);
		return;
	}

	fseek(file, 0, 2);
	length=ftell(file);
	rewind(file);

	words=new_dictionary();

	while(!feof(file)) {

		if(fgets(buffer, 1024, file)==NULL) break;
		if(buffer[0]=='#') continue;

		buffer[strlen(buffer)-1]='\0';
		upper(buffer);
		make_words(buffer, words);
		learn(model, words);


	}

	free_dictionary(words);
	fclose(file);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Show_Dictionary
 *
 *		Purpose:		Display the dictionary for training purposes.
 */
static void show_dictionary(DICTIONARY *dictionary)
{
	register int i;
	register int j;
	FILE *file;
	
	file=openfile(".dic", "w");
	if(file==NULL) {
		warn("show_dictionary", "Unable to open file \"%s%s%s%s\"", directory, SEP, megfileprefix, ".dic");
		return;
	}

	for(i=0; i<dictionary->size; ++i) {
		for(j=0; j<dictionary->entry[i].length; ++j)
			fprintf(file, "%c", dictionary->entry[i].word[j]);
		fprintf(file, "\n");
	}

	fclose(file);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Save_Model
 *
 *		Purpose:		Save the current state to a MegaHAL brain file.
 */
static void save_model(char *modelname, MODEL *model)
{

  return; //!!!!!!!!
  
	FILE *file;
	static char srcfilename[255];
	static char dstfilename[255];

	sprintf(srcfilename, "%s%s%s%s", directory, SEP, megfileprefix, modelname);
	sprintf(dstfilename, "%s~bak", srcfilename);
	
	show_dictionary(model->dictionary);
	putlog(LOG_MISC, "*", "Backing up \"%s\" file to \"%s\"...", srcfilename, dstfilename);
	copyfile(srcfilename, dstfilename);

	file=openfile(modelname, "wb");
	if(file==NULL) {
		warn("save_model", "Unable to open file \"%s\"", srcfilename);
		return;
	}

	fwrite(COOKIE, sizeof(char), strlen(COOKIE), file);
	fwrite(&(model->order), sizeof(BYTE1), 1, file);
	save_tree(file, model->forward);
	save_tree(file, model->backward);
	save_dictionary(file, model->dictionary);

	fclose(file);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Save_Tree
 *
 *		Purpose:		Save a tree structure to the specified file.
 */
static void save_tree(FILE *file, TREE *node)
{
	static int level=0;
	register int i;

	fwrite(&(node->symbol), sizeof(BYTE2), 1, file);
	fwrite(&(node->usage), sizeof(BYTE4), 1, file);
	fwrite(&(node->count), sizeof(BYTE2), 1, file);
	fwrite(&(node->branch), sizeof(BYTE2), 1, file);

	for(i=0; i<node->branch; ++i) {
		++level;
		save_tree(file, node->tree[i]);
		--level;
	}
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Load_Tree
 *
 *		Purpose:		Load a tree structure from the specified file.
 */
static void load_tree(FILE *file, TREE *node)
{
	static int level=0;
	register int i;

	fread(&(node->symbol), sizeof(BYTE2), 1, file);
	fread(&(node->usage), sizeof(BYTE4), 1, file);
	fread(&(node->count), sizeof(BYTE2), 1, file);
	fread(&(node->branch), sizeof(BYTE2), 1, file);

	if(node->branch==0) return;

	node->tree=(TREE **)nmalloc(sizeof(TREE *)*(node->branch));
	if(node->tree==NULL) {
		error("load_tree", "Unable to allocate subtree");
		return;
	}

	for(i=0; i<node->branch; ++i) {
		node->tree[i]=new_node();
		++level;
		load_tree(file, node->tree[i]);
		--level;
	}
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Load_Model
 *
 *		Purpose:		Load a model into memory.
 */
static bool load_model(char *filename, MODEL *model)
{
	FILE *file;
	unsigned char cookie[16];

	if(filename==NULL) return(FALSE);

	file=openfile(filename, "rb");
	if(file==NULL) {
		warn("load_model", "Unable to open file \"%s%s%s%s\"", directory, SEP, megfileprefix, filename);
		return(FALSE);
	}

	fread(cookie, sizeof(char), strlen(COOKIE), file);
	if(strncmp(cookie, COOKIE, strlen(COOKIE))!=0) {
		warn("load_model", "File \"%s%s%s%s\" is not a MegaHAL brain", directory, SEP, megfileprefix, filename);
		goto fail;
	}

	fread(&(model->order), sizeof(BYTE1), 1, file);
	load_tree(file, model->forward);
	load_tree(file, model->backward);
	load_dictionary(file, model->dictionary);

	fclose(file);
	return(TRUE);
fail:
	fclose(file);
	return(FALSE);
}
/*---------------------------------------------------------------------------*/

/*
 *    Function:   Make_Words
 *
 *    Purpose:    Break a string into an array of words.
 */
static void make_words(unsigned char *input, DICTIONARY *words)
{
	int offset=0;

	/*
	 *		Clear the entries in the dictionary
	 */
	free_dictionary(words);

	/*
	 *		If the string is empty then do nothing, for it contains no words.
	 */
	if(strlen(input)==0) return;

	/*
	 *		Loop forever.
	 */
	while(1) {

		/*
		 *		If the current character is of the same type as the previous
		 *		character, then include it in the word.  Otherwise, terminate
		 *		the current word.
		 */
		if(boundary(input, offset)) {
			/*
			 *		Add the word to the dictionary
			 */
			if(words->entry==NULL)
				words->entry=(STRING *)nmalloc((words->size+1)*sizeof(STRING));
			else
				words->entry=(STRING *)nrealloc(words->entry, (words->size+1)*sizeof(STRING));

			if(words->entry==NULL) {
				error("make_words", "Unable to nreallocate dictionary");
				return;
			}

			words->entry[words->size].length=offset;
			words->entry[words->size].word=input;
			words->size+=1;

			if(offset==(int)strlen(input)) break;
			input+=offset;
			offset=0;
		} else {
			++offset;
		}
	}

	/*
	 *		If the last word isn't punctuation, then replace it with a
	 *		full-stop character.
	 */
	if(egisalnum(words->entry[words->size-1].word[0])) {
		if(words->entry==NULL)
			words->entry=(STRING *)nmalloc((words->size+1)*sizeof(STRING));
		else
			words->entry=(STRING *)nrealloc(words->entry, (words->size+1)*sizeof(STRING));
		if(words->entry==NULL) {
			error("make_words", "Unable to nreallocate dictionary");
			return;
		}

		words->entry[words->size].length=1;
		words->entry[words->size].word=".";
		++words->size;
	}
	else if(strchr("!.?", words->entry[words->size-1].word[words->entry[words->size-1].length-1])==NULL) {
	  if(words->entry==NULL)
		words->entry=(STRING *)nmalloc((words->size+1)*sizeof(STRING));
	  else
		words->entry=(STRING *)nrealloc(words->entry, (words->size+1)*sizeof(STRING));

	  if(words->entry==NULL) {
		error("make_words", "Unable to reallocate dictionary");
		return;
	  }
	  words->entry[words->size].length=1;
	  words->entry[words->size].word=".";
          words->size+=1;
	}
   return;
}

/*---------------------------------------------------------------------------*/
/*
 *		Function:	Boundary
 *
 *		Purpose:		Return whether or not a word boundary exists in a string
 *						at the specified location.
 */
static bool boundary(unsigned char *string, int position)
{
	if(position==0)
		return(FALSE);

	if(position==(int)strlen(string))
		return(TRUE);

	if(
		(string[position]=='`' || string[position]=='\'' || string[position]=='&')&&
		(egisalpha(string[position-1])!=0)&&
		(egisalpha(string[position+1])!=0)
	)
		return(FALSE);

	if(
		(position>1)&&
		(string[position]=='`' || string[position-1]=='\'' || string[position-1]=='&')&&
		(egisalpha(string[position-2])!=0)&&
		(egisalpha(string[position])!=0)
	)
		return(FALSE);
	
	if(
		(egisalpha(string[position])!=0)&&
		(egisalpha(string[position-1])==0 && isdigit(string[position-1])==0)
	)
		return(TRUE);

	if(
		(egisalpha(string[position])==0 && isdigit(string[position])==0)&&
		(egisalpha(string[position-1])!=0)
	)
		return(TRUE);
	/*if(
		(egisalpha(string[position])!=0)&&
		(egisalpha(string[position-1])==0)
	)
		return(TRUE);

	if(
		(egisalpha(string[position])==0)&&
		(egisalpha(string[position-1])!=0)
	)
		return(TRUE);

	if(isdigit(string[position])!=isdigit(string[position-1]))
		return(TRUE);*/

	return(FALSE);
}

/*---------------------------------------------------------------------------*/
/*
 *    Function:   Generate_Reply
 *
 *    Purpose:    Take a string of user input and return a string of output
 *                which may vaguely be construed as containing a reply to
 *                whatever is in the input string.
 */
static unsigned char *generate_reply(MODEL *model, DICTIONARY *words)
{
	static DICTIONARY *dummy=NULL;
	DICTIONARY *replywords;
	DICTIONARY *keywords;
	float surprise;
	float max_surprise;
	unsigned char *output;
	static unsigned char *output_none=NULL;
	int count;
	int basetime;

	/*
	 *		Create an array of keywords from the words in the user's input
	 */
	keywords=make_keywords(model, words);

	/*
	 *		Make sure some sort of reply exists
	 */
	if(output_none==NULL) {
		output_none=nmalloc(40);
		if(output_none!=NULL)
			strcpy(output_none, "I don't know enough to answer you yet!");
	}
	output=output_none;
	if(dummy==NULL) dummy=new_dictionary();
	replywords=reply(model, dummy);
	if(dissimilar(words, replywords)==TRUE) output=make_output(replywords);

	/*
	 *		Loop for the specified waiting period, generating and evaluating
	 *		replies
	 */
	max_surprise=(float)-1.0;
/*	count=0; 
*/
	count=rnd(148+words->size);

	basetime=time(NULL); 
	do {    
		replywords=reply(model, keywords);
		surprise=evaluate_reply(model, keywords, replywords);
/*		++count; 
*/
		--count;
		if((surprise>max_surprise)&&(dissimilar(words, replywords)==TRUE)) {
			max_surprise=surprise;
			output=make_output(replywords);
		}
		if (!count) break;
/*	} while(count < 40);  */
	} while((time(NULL)-basetime)<timeout);

	/*
	 *		Return the best answer we generated
	 */
	return(output);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Dissimilar
 *
 *		Purpose:		Return TRUE or FALSE depending on whether the dictionaries
 *						are the same or not.
 */
static bool dissimilar(DICTIONARY *words1, DICTIONARY *words2)
{
	register int i;

	if(words1->size!=words2->size) return(TRUE);
	for(i=0; i<words1->size; ++i)
		if(wordcmp(words1->entry[i], words2->entry[i])!=0) return(TRUE);
	return(FALSE);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Make_Keywords
 *
 *		Purpose:		Put all the interesting words from the user's input into
 *						a keywords dictionary, which will be used when generating
 *						a reply.
 */
static DICTIONARY *make_keywords(MODEL *model, DICTIONARY *words)
{
	static DICTIONARY *keys=NULL;
	register int i;
	register int j;
	int c;

	if(keys==NULL) keys=new_dictionary();
	for(i=0; i<keys->size; ++i) nfree(keys->entry[i].word);
	free_dictionary(keys);

	for(i=0; i<words->size; ++i) {
		/*
		 *		Find the symbol ID of the word.  If it doesn't exist in
		 *		the model, or if it begins with a non-alphanumeric
		 *		character, or if it is in the exclusion array, then
		 *		skip over it.
		 */
		c=0;
		for(j=0; j<swp->size; ++j)
			if(wordcmp(swp->from[j], words->entry[i])==0) {
				add_key(model, keys, swp->to[j]);
				++c;
			}
		if(c==0) add_key(model, keys, words->entry[i]);
	}

	if(keys->size>0) for(i=0; i<words->size; ++i) {

		c=0;
		for(j=0; j<swp->size; ++j)
			if(wordcmp(swp->from[j], words->entry[i])==0) {
				add_aux(model, keys, swp->to[j]);
				++c;
			}
		if(c==0) add_aux(model, keys, words->entry[i]);
	}

	return(keys);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Add_Key
 *
 *		Purpose:		Add a word to the keyword dictionary.
 */
static void add_key(MODEL *model, DICTIONARY *keys, STRING word)
{
	int symbol;

	symbol=find_word(model->dictionary, word);
	if(symbol==0) return;
	if(egisalnum(word.word[0])==0) return;
	symbol=find_word(ban, word);
	if(symbol!=0) return;
	symbol=find_word(aux, word);
	if(symbol!=0) return;

	add_word(keys, word);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Add_Aux
 *
 *		Purpose:		Add an auxilliary keyword to the keyword dictionary.
 */
static void add_aux(MODEL *model, DICTIONARY *keys, STRING word)
{
	int symbol;

	symbol=find_word(model->dictionary, word);
	if(symbol==0) return;
	if(egisalnum(word.word[0])==0) return;
	symbol=find_word(aux, word);
	if(symbol==0) return;

	add_word(keys, word);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Reply
 *
 *		Purpose:		Generate a dictionary of reply words appropriate to the
 *						given dictionary of keywords.
 */
static DICTIONARY *reply(MODEL *model, DICTIONARY *keys)
{
	static DICTIONARY *replies=NULL;
	register int i;
	int symbol;
	bool start=TRUE;

	if(replies==NULL) replies=new_dictionary();
	free_dictionary(replies);

	/*
	 *		Start off by making sure that the model's context is empty.
	 */
	initialize_context(model);
	model->halcontext[0]=model->forward;
	used_key=FALSE;

	/*
	 *		Generate the reply in the forward direction.
	 */
	while(TRUE) {
		/*
		 *		Get a random symbol from the current context.
		 */
		if(start==TRUE) symbol=seed(model, keys);
		else symbol=babble(model, keys, replies);
		if((symbol==0)||(symbol==1)) break;
		start=FALSE;

		/*
		 *		Append the symbol to the reply dictionary.
		 */
		if(replies->entry==NULL)
			replies->entry=(STRING *)nmalloc((replies->size+1)*sizeof(STRING));
		else
			replies->entry=(STRING *)nrealloc(replies->entry, (replies->size+1)*sizeof(STRING));
		if(replies->entry==NULL) {
			error("reply", "Unable to nreallocate dictionary");
			return(NULL);
		}

		replies->entry[replies->size].length=
			model->dictionary->entry[symbol].length;
		replies->entry[replies->size].word=
			model->dictionary->entry[symbol].word;
		replies->size+=1;

		/*
		 *		Extend the current context of the model with the current symbol.
		 */
		update_context(model, symbol);
	}

	/*
	 *		Start off by making sure that the model's context is empty.
	 */
	initialize_context(model);
	model->halcontext[0]=model->backward;

	/*
	 *		Re-create the context of the model from the current reply
	 *		dictionary so that we can generate backwards to reach the
	 *		beginning of the string.
	 */
	if(replies->size>0) for(i=MIN(replies->size-1, model->order); i>=0; --i) {
		symbol=find_word(model->dictionary, replies->entry[i]);
		update_context(model, symbol);
	}

	/*
	 *		Generate the reply in the backward direction.
	 */
	while(TRUE) {
		/*
		 *		Get a random symbol from the current context.
		 */
		symbol=babble(model, keys, replies);
		if((symbol==0)||(symbol==1)) break;

		/*
		 *		Prepend the symbol to the reply dictionary.
		 */
		if(replies->entry==NULL)
			replies->entry=(STRING *)nmalloc((replies->size+1)*sizeof(STRING));
		else
			replies->entry=(STRING *)nrealloc(replies->entry, (replies->size+1)*sizeof(STRING));
		if(replies->entry==NULL) {
			error("reply", "Unable to nreallocate dictionary");
			return(NULL);
		}

		/*
		 *		Shuffle everything up for the prepend.
		 */
		for(i=replies->size; i>0; --i) {
			replies->entry[i].length=replies->entry[i-1].length;
			replies->entry[i].word=replies->entry[i-1].word;
		}

		replies->entry[0].length=model->dictionary->entry[symbol].length;
		replies->entry[0].word=model->dictionary->entry[symbol].word;
		replies->size+=1;

		/*
		 *		Extend the current context of the model with the current symbol.
		 */
		update_context(model, symbol);
	}

	return(replies);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Evaluate_Reply
 *
 *		Purpose:		Measure the average surprise of keywords relative to the
 *						language model.
 */
static float evaluate_reply(MODEL *model, DICTIONARY *keys, DICTIONARY *words)
{

	register int i;
	register int j;
	int symbol;
	float probability;
	int count;
	float entropy=(float)0.0;
	TREE *node;
	int num=0;

	if(words->size<=0) return((float)0.0);

	initialize_context(model);
	model->halcontext[0]=model->forward;
	for(i=0; i<words->size; ++i) {
		symbol=find_word(model->dictionary, words->entry[i]);

		if(find_word(keys, words->entry[i])!=0) {
			probability=(float)0.0;
			count=0;
			++num;
			for(j=0; j<model->order; ++j) if(model->halcontext[j]!=NULL) {

				node=find_symbol(model->halcontext[j], symbol);
				probability+=(float)(node->count)/
					(float)(model->halcontext[j]->usage);
				++count;

			}

			if(count>0.0) entropy-=(float)log(probability/(float)count);
		}

		update_context(model, symbol);
	}

	initialize_context(model);
	model->halcontext[0]=model->backward;
	for(i=words->size-1; i>=0; --i) {
		symbol=find_word(model->dictionary, words->entry[i]);

		if(find_word(keys, words->entry[i])!=0) {
			probability=(float)0.0;
			count=0;
			++num;
			for(j=0; j<model->order; ++j) if(model->halcontext[j]!=NULL) {

				node=find_symbol(model->halcontext[j], symbol);
				probability+=(float)(node->count)/
					(float)(model->halcontext[j]->usage);
				++count;

			}

			if(count>0.0) entropy-=(float)log(probability/(float)count);
		}

		update_context(model, symbol);
	}

	if(num>=8) entropy/=(float)sqrt(num-1);
	if(num>=16) entropy/=(float)num;

	return(entropy);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Make_Output
 *
 *		Purpose:		Generate a string from the dictionary of reply words.
 */
static unsigned char *make_output(DICTIONARY *words)
{
	static unsigned char *output=NULL;
	register int i;
	register int j;
	int length;
	static unsigned char *output_none=NULL;

	if(output_none==NULL) output_none=nmalloc(40);

	if(output==NULL) {
		output=(unsigned char *)nmalloc(sizeof(unsigned char));
		if(output==NULL) {
			error("make_output", "Unable to allocate output");
			return(output_none);
		}
	}

	if(words->size==0) {
		if(output_none!=NULL)
			strcpy(output_none, "I am utterly speechless!");
		return(output_none);
	}

	length=1;
	for(i=0; i<words->size; ++i) length+=(words->entry[i].length + 1);

	output=(unsigned char *)nrealloc(output, sizeof(unsigned char)*length);
	if(output==NULL) {
		error("make_output", "Unable to nreallocate output.");
		if(output_none!=NULL)
			strcpy(output_none, "I forgot what I was going to say!");
		return(output_none);
	}

	length=0;
	for(i=0; i<words->size; ++i) {
	  if((i>0)&&(strchr(charspaces, words->entry[i].word[0])==NULL)&&(strchr(charspaces, output[(length-1)])==NULL))
	    output[length++]='\040';
	  for(j=0; j<words->entry[i].length; ++j) {
	    if(words->entry[i].word[j] == '\t') {
	      output[length++]='\0';
	      break;
	    }
	    else
	    output[length++]=words->entry[i].word[j];
	  }
	}
	output[length]='\0';
	return(output);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Babble
 *
 *		Purpose:		Return a random symbol from the current context, or a
 *						zero symbol identifier if we've reached either the
 *						start or end of the sentence.  Select the symbol based
 *						on probabilities, favouring keywords.  In all cases,
 *						use the longest available context to choose the symbol.
 */
static int babble(MODEL *model, DICTIONARY *keys, DICTIONARY *words)
{
	TREE *node;
	register int i;
	int count;
	int symbol;

	/*
	 *		Select the longest available context.
	 */
	for(i=0; i<=model->order; ++i)
		if(model->halcontext[i]!=NULL)
			node=model->halcontext[i];

	if(node->branch==0) return(0);

	/*
	 *		Choose a symbol at random from this context.
	 */
	i=rnd(node->branch);
	count=rnd(node->usage);
	while(count>=0) {
		/*
		 *		If the symbol occurs as a keyword, then use it.  Only use an
		 *		auxilliary keyword if a normal keyword has already been used.
		 */
		symbol=node->tree[i]->symbol;

		if(
			(find_word(keys, model->dictionary->entry[symbol])!=0)&&
			((used_key==TRUE)||
			(find_word(aux, model->dictionary->entry[symbol])==0))&&
			(word_exists(words, model->dictionary->entry[symbol])==FALSE)
		) {
			used_key=TRUE;
			break;
		}
		count-=node->tree[i]->count;
		i=(i>=(node->branch-1))?0:i+1;
	}

	return(symbol);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Word_Exists
 *
 *		Purpose:		A silly brute-force searcher for the reply string.
 */
static bool word_exists(DICTIONARY *dictionary, STRING word)
{
	register int i;

	for(i=0; i<dictionary->size; ++i)
		if(wordcmp(dictionary->entry[i], word)==0)
			return(TRUE);
	return(FALSE);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Seed
 *
 *		Purpose:		Seed the reply by guaranteeing that it contains a
 *						keyword, if one exists.
 */
static int seed(MODEL *model, DICTIONARY *keys)
{
	register int i;
	int symbol;
	int stop;

	/*
	 *		Fix, thanks to Mark Tarrabain
	 */
	if(model->halcontext[0]->branch==0) symbol=0;
	else symbol=model->halcontext[0]->tree[rnd(model->halcontext[0]->branch)]->symbol;

	if(keys->size>0) {
		i=rnd(keys->size);
		stop=i;
		while(TRUE) {
			if(
				(find_word(model->dictionary, keys->entry[i])!=0)&&
				(find_word(aux, keys->entry[i])==0)
			) {
				symbol=find_word(model->dictionary, keys->entry[i]);
				return(symbol);
			}
			++i;
			if(i==keys->size) i=0;
			if(i==stop) return(symbol);
		}
	}

	return(symbol);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	New_Swap
 *
 *		Purpose:		Allocate a new swap structure.
 */
static SWAP *new_swap(void)
{
	SWAP *list;

	list=(SWAP *)nmalloc(sizeof(SWAP));
	if(list==NULL) {
		error("new_swap", "Unable to allocate swap");
		return(NULL);
	}
	list->size=0;
	list->from=NULL;
	list->to=NULL;

	return(list);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Add_Swap
 *
 *		Purpose:		Add a new entry to the swap structure.
 */
static void add_swap(SWAP *list, unsigned char *s, unsigned char *d)
{
	list->size+=1;

	if(list->from==NULL) {
		list->from=(STRING *)nmalloc(sizeof(STRING));
		if(list->from==NULL) {
			error("add_swap", "Unable to allocate list->from");
			return;
		}
	}

	if(list->to==NULL) {
		list->to=(STRING *)nmalloc(sizeof(STRING));
		if(list->to==NULL) {
			error("add_swap", "Unable to allocate list->to");
			return;
		}
	}

	list->from=(STRING *)nrealloc(list->from, sizeof(STRING)*(list->size));
	if(list->from==NULL) {
		error("add_swap", "Unable to nreallocate from");
		return;
	}

	list->to=(STRING *)nrealloc(list->to, sizeof(STRING)*(list->size));
	if(list->to==NULL) {
		error("add_swap", "Unable to nreallocate to");
		return;
	}

	list->from[list->size-1].length=strlen(s);
	list->from[list->size-1].word=mystrdup(s);
	list->to[list->size-1].length=strlen(d);
	list->to[list->size-1].word=mystrdup(d);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Initialize_Swap
 *
 *		Purpose:		Read a swap structure from a file.
 */
static SWAP *initialize_swap(char *filename)
{
	SWAP *list;
	FILE *file=NULL;
	unsigned char buffer[1024];
	unsigned char *from;
	unsigned char *to;

	list=new_swap();

	if(filename==NULL) return(list);

	file=openfile(filename, "r");
	if(file==NULL) return(list);

	while(!feof(file)) {

		if(fgets(buffer, 1024, file)==NULL) break;
		if(buffer[0]=='#') continue;
		upper(buffer);
		from=strtok(buffer, "\t ");
		to=strtok(NULL, "\t \n#");

		add_swap(list, from, to);
	}

	fclose(file);
	return(list);
}

/*---------------------------------------------------------------------------*/

static void free_swap(SWAP *swap)
{
	register int i;

	if(swap==NULL) return;

	for(i=0; i<swap->size; ++i) {
		free_word(swap->from[i]);
		free_word(swap->to[i]);
	}
	nfree(swap->from);
	swap->from=NULL;
	nfree(swap->to);
	swap->to=NULL;
	nfree(swap);
	swap==NULL;
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Initialize_List
 *
 *		Purpose:		Read a dictionary from a file.
 */
static DICTIONARY *initialize_list(char *filename)
{
	DICTIONARY *list;
	FILE *file=NULL;
	STRING word;
	unsigned char *string;
	unsigned char buffer[1024];
	
	list=new_dictionary();

	if(filename==NULL) return(list);

	file=openfile(filename, "r");
	if(file==NULL) return(list);

	while(!feof(file)) {

		if(fgets(buffer, 1024, file)==NULL) break;
		if(buffer[0]=='#') continue;
		upper(buffer);
		string=strtok(buffer, "\t \n#");

		if((string!=NULL)&&(strlen(string)>0)) {
			word.length=strlen(string);
			word.word=mystrdup(buffer);
			add_word(list, word);
		}
	}

	fclose(file);
	return(list);
}

/*---------------------------------------------------------------------------*/

/*
 *		Function:	Rnd
 *
 *		Purpose:		Return a random integer between 0 and range-1.
 */
static int rnd(int range)
{
	static bool flag=FALSE;

	if(flag==FALSE) {
		srand48(time(NULL));
	}
	flag=TRUE;
	return(floor(drand48()*(double)(range)));
}

/*---------------------------------------------------------------------------*/
static void unload_personality(MODEL **model)
{
	save_model(".brn", *model);
	free_model(*model);
	free_alldic;

}
static void free_alldic(void)
{
	free_words(ban);
	if(ban!=NULL) {
	  free_dictionary(ban);
	  nfree(ban);
	  ban=NULL; 
	}
	free_words(aux);
	if(aux!=NULL) {
	  free_dictionary(aux);
	  nfree(aux);
	  aux=NULL; 
	}
	free_swap(swp);
}
static void appendload(MODEL **model)
{
	static char *filename=".trn";

	train(*model, filename);

	return;
}
static void load_personality(MODEL **model)
{
	Context;

	/*
	 *		Free the current personality
	 */
	free_model(*model);
	free_alldic;
	Context;

	/*
	 *		Create a language model.
	 */
	*model=new_model(order);
	Context;

	/*
	 *		Train the model on a text if one exists
	 */
/*	if(load_model(".brn", *model)==FALSE) {
		train(*model, ".trn");
	}!!!!!!!!!!!!!*/
	train(*model, ".msg");
	Context;

	/*
	 *		Read a dictionary containing banned keywords, auxiliary keywords,
	 *		greeting keywords and swap keywords
	 */
	ban=initialize_list(".ban");
	aux=initialize_list(".aux");
	swp=initialize_swap(".swp");
	Context;
	
}

/*---------------------------------------------------------------------------*/

static void change_personality(DICTIONARY *command, int position, MODEL **model)
{
	directory = megpatch;
	last = mystrdup(directory);
	/*if(last!=NULL) { nfree(last); last=NULL; }
	if(directory!=NULL) last=mystrdup(directory);
	else directory=(char *)nmalloc(sizeof(char)*1);
	if(directory==NULL)
		error("change_personality", "Unable to allocate directory");
	if((command==NULL)||((position+2)>=command->size)) {
		directory=(char *)nrealloc(directory, sizeof(char)*(strlen(DEFAULT)+1));
		if(directory==NULL)
			error("change_personality", "Unable to allocate directory");
		strcpy(directory, DEFAULT);
		if(last==NULL) last=mystrdup(directory);
	} else {
		directory=(char *)nrealloc(directory,
			sizeof(char)*(command->entry[position+2].length+1));
		if(directory==NULL)
			error("change_personality", "Unable to allocate directory");
		strncpy(directory, command->entry[position+2].word,
			command->entry[position+2].length);
		directory[command->entry[position+2].length]='\0';
	}*/
	load_personality(model);
}

/*---------------------------------------------------------------------------*/

static void free_words(DICTIONARY *words)
{
	register int i;

	if(words==NULL) return;

	if(words->entry!=NULL) 
		for(i=0; i<words->size; ++i) free_word(words->entry[i]);

}

/*---------------------------------------------------------------------------*/

static void free_word(STRING word)
{
	nfree(word.word);
}

/*===========================================================================*/
/* vd */
/*===========================================================================*/
static void save_msg(MODEL *model)
{
    FILE *file;
    BYTE4 savusage;
    BYTE2 savcount;
    BYTE2 savbranch;
    register int i;

	  static char srcfilename[255];
	  static char dstfilename[255];
    struct stat st;
    int srcfilesize;
    int dstfilesize;
    
    Context;




    sprintf(srcfilename, "%s%s%s%s", directory, SEP, megfileprefix, ".msg");
    sprintf(dstfilename, "%s~bak", srcfilename);

    stat(srcfilename, &st);
    srcfilesize = st.st_size;

    stat(dstfilename, &st);
    dstfilesize = st.st_size;

    putlog(LOG_MISC, "*", "Backing up \"%s\" (%d) file to \"%s\" (%d)...", srcfilename, srcfilesize, dstfilename, dstfilesize);

    if (srcfilesize > dstfilesize) {        
        copyfile(srcfilename, dstfilename);
    }



    file=openfile(".msg", "w");
    if(file==NULL) {
		warn("save_msg", "Unable to open file \"%s%s%s%s\"", directory, SEP, megfileprefix, ".msg");
		return;
    }
    savusage=model->forward->usage;
    savcount=model->forward->count;
    savbranch=model->forward->branch;

    model->forward->usage=savbranch;
    model->forward->count=savbranch;
    model->forward->branch=savbranch;


    model->backward->usage=savbranch;
    model->backward->count=savbranch;
    model->backward->branch=savbranch;


    Context;
    msg_cleartreeusage(model->forward);
    Context;
    msg_cleartreeusage(model->backward);

/* -------- */
    initialize_context(model); 
    model->halcontext[0]=model->backward; 

    Context;
    msgsave_tree(file, model->backward);
    fclose(file);
/* -------- */

    model->forward->branch=savbranch;
    model->backward->branch=savbranch;

    Context;
    msg_restoretreeusage(model->forward);
    Context;
    msg_restoretreeusage(model->backward);

    model->forward->usage=savusage;
    model->forward->count=savcount;
    model->backward->usage=savusage;
    model->backward->count=savcount;

}
/*---------------------------------------------------------------------------*/
static void msgsave_tree(FILE *file, TREE *nodein)
{
    static BYTE2 *symbols_order=NULL;
    static BYTE2 *symbols_output=NULL;
    static unsigned char *output=NULL;
    static int length;
    static int level=0;
    register int i;
    register int j;
    register int k;
    int symbols_index=0;
    TREE *node=NULL;
    BYTE2 symbol;

    if(symbols_order==NULL) symbols_order=(BYTE2 *)nmalloc(sizeof(BYTE2)*(model->order+2)+1);
    if(symbols_output==NULL) symbols_output=(BYTE2 *)nmalloc(sizeof(BYTE2)*MAXOUTPUTSYMBOLS+1);
    if(output==NULL) output=(char *)nmalloc(sizeof(char)*MAXOUTPUT+1);

    symbol=nodein->symbol;
    symbols_order[(model->order+2-level)] = symbol;

    if((nodein->branch==0)&&(symbol==1)&&(level==(model->order+1))) {
      symbols_index=0;
      output[0]='\0';
      length=0;
      initialize_context(model); 
      model->halcontext[0]=model->backward; 
      for(j=level;j>=1;--j) {
        symbol=symbols_order[j];
        update_context(model, symbol);
        symbols_output[++symbols_index]=symbol;
	if(symbol==1) break;
      }
      while(1) {
        for(j=0; j<=model->order; ++j)
          if(model->halcontext[j]!=NULL) 
            node=model->halcontext[j];
        if(node->branch==0) break;
        symbol=node->tree[node->usage]->symbol;
        node->usage+=1;
        if(node->usage>=node->branch) node->usage=0;
        update_context(model, symbol);
        symbols_output[++symbols_index]=symbol;
	if(symbol==1) break;
      }	

      initialize_context(model); 
      model->halcontext[0]=model->forward; 

      for(k=symbols_index;k>0;--k) {
        symbol=symbols_output[k];
        update_context(model, symbol);
        if(symbol>1) msg_makeoutput(output, &length, symbol);
      }	
      while(1) {
        for(j=0; j<=model->order; ++j)
          if(model->halcontext[j]!=NULL) 
            node=model->halcontext[j];
        if(node->branch==0) break;
	if(symbol==1) break;
        symbol=node->tree[node->usage]->symbol;
        node->usage+=1;
        if(node->usage>=node->branch) node->usage=0;
        update_context(model, symbol);
        if(symbol>1) msg_makeoutput(output, &length, symbol);
      }	
      capitalize(output);
      fprintf(file, "%s\n",output); 
    }
    for(i=0; i<nodein->branch; ++i) {
	++level;
        msgsave_tree(file, nodein->tree[i]); 
	--level;
    }
    if(level==0){
      nfree(symbols_order);
      nfree(symbols_output);
      nfree(output);
      symbols_order=NULL;
      symbols_output=NULL;
      output=NULL;
    }
}
/*---------------------------------------------------------------------------*/
static void msg_makeoutput(char *output, int *length, BYTE2 symbol)
{
    register int j;

    if((*length>0)&&(strchr(charspaces, model->dictionary->entry[symbol].word[0])==NULL)&&(strchr(charspaces, output[(*length-1)])==NULL)) {
	    output[*length]='\040';
	    *length+=1;
    }
    for(j=0; j<model->dictionary->entry[symbol].length; ++j) {
	if(model->dictionary->entry[symbol].word[j] == '\t') {
	  output[*length]='\0';
	  *length+=1;
	  break;
	}
	else
	  output[*length]=model->dictionary->entry[symbol].word[j];
	*length+=1;
    }
    output[*length]='\0';
}

/*---------------------------------------------------------------------------*/
static void msg_cleartreeusage(TREE *node)
{
    register int i;

    node->usage=0;

    for(i=0; i<node->branch; ++i) {
        msg_cleartreeusage(node->tree[i]); 
    }
}
/*---------------------------------------------------------------------------*/
static void msg_restoretreeusage(TREE *node)
{
    register int i;

    if(node->branch==0)
      node->usage=0;
    else
      node->usage=node->count;

    for(i=0; i<node->branch; ++i) {
        msg_restoretreeusage(node->tree[i]); 
    }
}
/*---------------------------------------------------------------------------*/
static int expmem_model(void)
{
	int size=0;
        globsize = 0;
	if(model==NULL) return(0);
	if(model->forward!=NULL) {
		size+=expmem_tree(model->forward);
	}
        globsize = 0;
	if(model->backward!=NULL) {
		size+=expmem_tree(model->backward);
	}
	if(model->dictionary!=NULL) {
		size+=expmem_dictionary(model->dictionary);
	}
	return(size);
}
/*---------------------------------------------------------------------------*/
static int expmem_tree(TREE *tree)
{
	register int i;

	if(tree==NULL) return(globsize);
        globsize+= sizeof(TREE) + 4 + 10;
	if(tree->tree!=NULL) {
		for(i=0; i<tree->branch; ++i) {
			expmem_tree(tree->tree[i]);
		}
	}
	return(globsize);
}
/*---------------------------------------------------------------------------*/
static int expmem_dictionary(DICTIONARY *word)
{
	register int i;
	int size;

	if(word==NULL) return(size);
	size = (word->size * (sizeof(STRING) +sizeof(BYTE2)) ) + sizeof(DICTIONARY);
	for(i=0;i<word->size;++i) 
          size+=word->entry[i].length +1;
	return(size);
}
/*---------------------------------------------------------------------------*/
static int expmem_swap(SWAP *swap)
{
	register int i;
	int size;

	if(swap==NULL) return(size);
	size = (swap->size * (sizeof(STRING)+sizeof(BYTE2)) * 2) + (sizeof(DICTIONARY)*2);

	for(i=0;i<swap->size;++i) {
          size+=swap->from[i].length +1;
          size+=swap->to[i].length +1;
        }
	return(size);
}

static FILE *openfile(char *name, char *mode)
{
	FILE *file=NULL;
	static char *filename=NULL;

	if(filename==NULL) filename=(char *)nmalloc(sizeof(char)*1);
		filename=(char *)nrealloc(filename, sizeof(char)*(strlen(directory)+strlen(SEP)+strlen(megfileprefix)+strlen(name)+1));
	if(filename==NULL) {
		error("openfile","Unable to allocate filename %s", name);
	} else {
		sprintf(filename, "%s%s%s%s", directory, SEP, megfileprefix, name);
		if(filename==NULL) {
			error("openfile","no open file, filename is NULL");
		} else {
			file=fopen(filename, mode);
			nfree(filename);
			filename=NULL;
		}
	}
	return file;
}


/*===========================================================================*/
/*
 *		$Log: megahal.c,v $
 *		Revision 1.25  1999/10/21 03:42:48  hutch
 *		Fixed problem on some operating systems caused by stderr and stdout not
 *		being of type FILE *.
 *
 * Revision 1.24  1998/09/03  03:07:09  hutch
 * Don't know.
 *
 *		Revision 1.23  1998/05/19 03:02:02  hutch
 *		Removed a small nmalloc() bug, and added a progress display for
 *		generate_reply().
 *
 *		Revision 1.22  1998/04/24 03:47:03  hutch
 *		Quick bug fix to get sunos version to work.
 *
 *		Revision 1.21  1998/04/24 03:39:51  hutch
 *		Added the BRAIN command, to allow user to change MegaHAL personalities
 *		on the fly.
 *
 *		Revision 1.20  1998/04/22 07:12:37  hutch
 *		A few small changes to get the DOS version to compile.
 *
 *		Revision 1.19  1998/04/21 10:10:56  hutch
 *		Fixed a few little errors.
 *
 *		Revision 1.18  1998/04/06 08:02:01  hutch
 *		Added debugging stuff, courtesy of Paul Baxter.
 *
 *		Revision 1.17  1998/04/02 01:34:20  hutch
 *		Added the help function and fixed a few errors.
 *
 *		Revision 1.16  1998/04/01 05:42:57  hutch
 *		Incorporated Mac code, including speech synthesis, and attempted
 *		to tidy up the code for multi-platform support.
 *
 *		Revision 1.15  1998/03/27 03:43:15  hutch
 *		Added AMIGA specific changes, thanks to Dag Agren.
 *
 *		Revision 1.14  1998/02/20 06:40:13  hutch
 *		Tidied up transcript file format.
 *
 *		Revision 1.13  1998/02/20 06:26:19  hutch
 *		Fixed random number generator and Seed() function (thanks to Mark
 *		Tarrabain), removed redundant code left over from the Loebner entry,
 *		prettied things up a little and destroyed several causes of memory
 *		leakage (although probably not all).
 *
 *		Revision 1.12  1998/02/04 02:55:11  hutch
 *		Fixed up memory allocation error which caused SunOS versions to crash.
 *
 *		Revision 1.11  1998/01/22 03:16:30  hutch
 *		Fixed several memory leaks, and the frustrating bug in the
 *		Write_Input routine.
 *
 *		Revision 1.10  1998/01/19 06:44:36  hutch
 *		Fixed MegaHAL to compile under Linux with a small patch credited
 *		to Joey Hess (joey@kitenet.net).  MegaHAL may now be included as
 *		part of the Debian Linux distribution.
 *
 *		Revision 1.9  1998/01/19 06:37:32  hutch
 *		Fixed a minor bug with end-of-sentence punctuation.
 *
 *		Revision 1.8  1997/12/24 03:17:01  hutch
 *		More bug fixes, and hopefully the final contest version!
 *
 *		Revision 1.7  1997/12/22  13:18:09  hutch
 *		A few more bug fixes, and non-repeating implemented.
 *
 *		Revision 1.6  1997/12/22 04:27:04  hutch
 *		A few minor bug fixes.
 *
 *		Revision 1.5  1997/12/15 04:35:59  hutch
 *		Final Loebner version!
 *
 *		Revision 1.4  1997/12/11 05:45:29  hutch
 *		The almost finished version.
 *
 *		Revision 1.3  1997/12/10 09:08:09  hutch
 *		Now Loebner complient (tm).
 *
 *		Revision 1.2  1997/12/08 06:22:32  hutch
 *		Tidied up.
 *
 *		Revision 1.1  1997/12/05  07:11:44  hutch
 *		Initial revision (lots of files were merged into one, RCS re-started)
 *
 *		Revision 1.7  1997/12/04 07:07:13  hutch
 *		Added load and save functions, and tidied up some code.
 *
 *		Revision 1.6  1997/12/02 08:34:47  hutch
 *		Added the ban, aux and swp functions.
 *
 *		Revision 1.5  1997/12/02 06:03:04  hutch
 *		Updated to use a special terminating symbol, and to store only
 *		branches of maximum depth, as they are the only ones used in
 *		the reply.
 *
 *		Revision 1.4  1997/10/28 09:23:12  hutch
 *		MegaHAL is babbling nicely, but without keywords.
 *
 *		Revision 1.3  1997/10/15  09:04:03  hutch
 *		MegaHAL can parrot back whatever the user says.
 *
 *		Revision 1.2  1997/07/21 04:03:28  hutch
 *		Fully working.
 *
 *		Revision 1.1  1997/07/15 01:55:25  hutch
 *		Initial revision.
 */
/*===========================================================================*/

