#
# Quake2 gamei386.so Makefile for Linux
#

# this nice line comes from the linux kernel makefile
ARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ -e s/arm.*/arm/ -e s/sa110/arm/ -e s/alpha/axp/)
CC = gcc -std=c11 -Wall

# This is for native build
CFLAGS = -O3 -DARCH="$(ARCH)"
# This is for 32-bit build on 64-bit host
ifeq ($(ARCH), i386)
CFLAGS += -m32 -DSTDC_HEADERS -I/usr/include
endif

ifeq ($(shell uname),Linux)
#CFLAGS+=-DNEED_STRLCPY
endif

# This enables warnings if a strlcat or strlcpy would have
# caused an overflow.
#CFLAGS+=-DSTRL_DEBUG

# This causes a backtrace to be emitted for detected buffer overflows
# Works only on linux
#CFLAGS+=-DSTRL_DEBUG_BACKTRACE -rdynamic

LDFLAGS=-ldl -lm
SHLIBEXT=so
SHLIBCFLAGS=-fPIC
SHLIBLDFLAGS=-shared

DO_CC=$(CC) $(CFLAGS) $(SHLIBCFLAGS) -o $@ -c $<

#############################################################################
# SETUP AND BUILD
# GAME
#############################################################################

.c.o:
	$(DO_CC)

GAME_OBJS = \
	p_client.o g_cmds.o g_combat.o g_func.o g_items.o \
	g_main.o g_misc.o g_phys.o g_save.o g_spawn.o \
	g_target.o g_trigger.o g_turret.o g_utils.o g_weapon.o m_move.o \
	p_hud.o p_trail.o p_view.o p_weapon.o q_shared.o g_svcmds.o g_chase.o \
	lithium.o l_display.o l_fragtrak.o l_gslog.o l_hook.o \
	l_mapqueue.o l_nocamp.o l_obit.o l_pack.o l_rune.o \
	l_var.o l_menu.o l_admin.o l_vote.o l_net.o net.o \
	g_ctf.o l_hscore.o zbotcheck.o strl.o

lithium/game$(ARCH).$(SHLIBEXT): $(GAME_OBJS) 
	$(CC) $(CFLAGS) $(SHLIBLDFLAGS) -o $@ $(GAME_OBJS) $(LDFLAGS)


#############################################################################
# MISC
#############################################################################

all:
	$(MAKE) clean
	$(MAKE) depend
	$(MAKE)

clean:
	rm -f $(GAME_OBJS)

depend:
	gcc -MM $(GAME_OBJS:.o=.c) > dependencies

#############################################################################
# DEPENDENCIES
#############################################################################

# Automatically maintain dependencies by running make all or make depend.

-include dependencies
