# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-emulation/darcnes/darcnes-0401-r1.ebuild,v 1.2 2002/07/11 06:30:12 drobbins Exp $

S=${WORKDIR}/darcnes
DESCRIPTION="A multi-system emulator"
SRC_URI="http://www.dridus.com/~nyef/darcnes/download/dn9b0401.tgz"
HOMEPAGE="http://www.netway.com/~nyef"

DEPEND=">=media-libs/svgalib-1.4.2
	X? ( virtual/x11 )
	gtk? ( =x11-libs/gtk+-1.2* )"

src_compile() {

    cp cd_unix.c cd_unix.c.orig
    cat cd_unix.c.orig | sed "s:CDROM_DEVICE \"/dev/cdrom\"$:CDROM_DEVICE \"/dev/cdroms/cdrom0\":"\
	> cd_unix.c
    cp Makefile Makefile.orig
    if [ "`use X`" ]
    then
	if [ "`use gtk`" ]
	then
            cat Makefile.orig | sed "s:^TARGET?=Linux_X$:TARGET?=Linux_GTK:" \
                > Makefile
	fi
	try make
    fi
    cat Makefile.orig | sed "s:^TARGET?=Linux_X$:TARGET?=Linux_svgalib:" \
        > Makefile
    try make

}

src_install () {

    exeinto /usr/bin
    doexe sdarcnes
    if [ "`use X`" ]
    then
	exeinto /usr/bin
        doexe darcnes
    fi
    dodoc readme

}
