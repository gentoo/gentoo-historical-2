####################################################################
#         Copyright 1999-2003 Gentoo Technologies, Inc.            #
# Distributed under the terms of the GNU General Public License v2 #
####################################################################
# chpax	prefix	description
# p	PE	do not enforce paging based non-executable pages
# E	ET	emulate trampolines
# r	RE	do not randomize mmap() base [ELF only]
# m	ME	do not restrict mprotect()
# s	SE	do not enforce segmentation based non-executable pages
# x	XE	do not randomize ET_EXEC base [ELF only]

# NOTE:  PS_EXEC_EXEMPT is {PAGE,SEGM}_EXEC_EXEMPT.  For executables
# with BOTH, you should use this, as it enables -e and -m, to make
# sure that pax doesn't cry about odd flag settings in softmode

# "blkdwn_java" would be blackdown-jdk or blackdown-jre

# chpax command.  If using multiple tools, can separate by spaces.
# This one hits BOTH chpax and paxctl
CHPAX="/sbin/chpax /sbin/paxctl"
#CHPAX="/sbin/paxctl"
#CHPAX="/sbin/chpax"

# yes to be annoyed
VERBOSE="no"

PSE_wine=/usr/lib/wine/bin/{wine{,build,clipsrv,dump,gcc,server,wrap,-{k,p}thread},w{mc,rc,idl}}
PSE_blkdwn_java=/opt/blackdown-{jdk-*/{,jre/},jre-*/}bin/{java{,_vm,c},keytool,kinit,klist,ktab,orbd,policytool,rmi{d,registry},servertool,tnameserv}
PSE_openoffice=/opt/OpenOffice.org*/program/soffice.bin
PSE_misc="/usr/X11R6/bin/XFree86 /usr/bin/xmms /usr/bin/{,g}mplayer \
 /usr/bin/blender /usr/bin/gxine /usr/bin/xine /usr/bin/totem /usr/bin/acme \
 /usr/bin/gnome-sound-recorder /usr/games/bin/bzflag /usr/bin/xfce4-panel"

RE_blkdwn_java="${SPE_blkdwn_java} /usr/X11R6/bin/XFree86"

ME_blkdwn_java="${PSE_blkdwn_java}"
# or plug-ins don't work
ME_misc=/usr/lib/MozillaFirefox/firefox{,-bin}

XE_blkdwn_java="${PSE_blkdwn_java} /usr/X11R6/bin/XFree86"


####################################
# Settings are really applied here #
####################################

PS_EXEC_EXEMPT="${PSE_misc} ${PSE_wine} ${PSE_blkdwn_java} ${PSE_openoffice}"
PAGEEXEC_EXEMPT=""
TRAMPOLINE_EXEMPT=""
MPROTECT_EXEMPT="${ME_blkdwn_java} ${ME_misc}"
RANDMMAP_EXEMPT="${RE_blkdwn_java}"
SEGMEXEC_EXEMPT="${PAGEEXEC_EXEMPT}"
RANDEXEC_EXEMPT="${XE_blkdwn_java}"

# when zero flag mask is set to "yes" it will remove all pax flags from all files on reboot/stop
ZERO_FLAG_MASK="yes"
