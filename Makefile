#
# Quake2 gamei386.so Makefile for Linux 2.0
#
# Jan '98 by Zoid <zoid@idsoftware.com>
#
# ELF only
#
# Probably requires GNU make
#
# This builds the gamei386.so for Linux based on the q2source_12_11.zip
# release.  
# Put his Makefile in the game subdirectory you get when you unzip
# q2source_12_11.zip.
#
# There are two compiler errors you'll get, the following fixes
# are necessary:
#
# In g_local.h (around line 828), you must change the 
#    typedef struct g_client_s { ... } gclient_t;
# to just:
#    struct g_client_s { ... };
# The typedef is already defined elsewhere (seems to compile fine under
# MSCV++ for Win32 for some reason).
#
# m_player.h has a Ctrl-Z at the end (damn DOS editors).  Remove it or
# gcc complains.
#
# Note that the source in q2source_12_11.zip is for version 3.05.  To
# get it to run with Linux 3.10, change the following in game.h:
#    #define    GAME_API_VERSION        1
# change it to:
#    #define    GAME_API_VERSION        2

# this nice line comes from the linux kernel makefile
ARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ -e s/arm.*/arm/ -e s/sa110/arm/ -e s/alpha/axp/)
CC = gcc -std=c11

# This is for native build
CFLAGS = -O3 -DARCH="$(ARCH)"
# This is for 32-bit build on 64-bit host
ifeq ($(ARCH), i386)
CFLAGS += -m32 -DSTDC_HEADERS -I/usr/include
endif

ifeq ($(shell uname),Linux)
CFLAGS+=-DNEED_STRLCAT -DNEED_STRLCPY
endif

# This enables warnings if a strlcat or strlcpy would have
# caused an overflow.
# CFLAGS+=-DSTRL_DEBUG

# This causes a backtrace to be emitted for detected buffer overflows
# Works only on linux
# CFLAGS+=-DSTRL_DEBUG_BACKTRACE -rdynamic

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
	$(MAKE)

clean:
	rm -f $(GAME_OBJS)

depend:
	gcc -MM $(GAME_OBJS:.o=.c)

#############################################################################
# DEPENDENCIES
#############################################################################

p_client.o: p_client.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h m_player.h
g_cmds.o: g_cmds.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h m_player.h
g_combat.o: g_combat.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_func.o: g_func.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_items.o: g_items.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_main.o: g_main.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_misc.o: g_misc.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_phys.o: g_phys.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_save.o: g_save.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_spawn.o: g_spawn.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_target.o: g_target.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_trigger.o: g_trigger.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_turret.o: g_turret.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_utils.o: g_utils.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_weapon.o: g_weapon.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
m_move.o: m_move.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
p_hud.o: p_hud.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
p_trail.o: p_trail.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
p_view.o: p_view.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h m_player.h
p_weapon.o: p_weapon.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h m_player.h
q_shared.o: q_shared.c q_shared.h strl.h
g_svcmds.o: g_svcmds.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
g_chase.o: g_chase.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
lithium.o: lithium.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_display.o: l_display.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_fragtrak.o: l_fragtrak.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h fragtrak.h
l_gslog.o: l_gslog.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_hook.o: l_hook.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_mapqueue.o: l_mapqueue.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_nocamp.o: l_nocamp.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_obit.o: l_obit.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_pack.o: l_pack.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_rune.o: l_rune.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_var.o: l_var.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_menu.o: l_menu.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_admin.o: l_admin.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_vote.o: l_vote.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_net.o: l_net.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h net.h
net.o: net.c net.h strl.h
g_ctf.o: g_ctf.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
l_hscore.o: l_hscore.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
zbotcheck.o: zbotcheck.c g_local.h q_shared.h strl.h game.h g_ctf.h lithium.h
strl.o: strl.c strl.h
