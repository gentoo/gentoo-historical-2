# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-util/cvsup/cvsup-16.1e.ebuild,v 1.1 2002/02/18 19:23:51 danarmak Exp $

S=${WORKDIR}/cvsup
DESCRIPTION="a faster alternative to cvs. binary version"
SRC_URI="http://people.freebsd.org/~jdp/s1g/debian/cvsup-16.1e-LINUXLIBC6-gui.tar.gz"
HOMEPAGE="http://people.freebsd.org/~jdp/s1g/"

src_unpack() {

    cd ${WORKDIR}
    mkdir cvsup
    cd cvsup
    unpack $A
    
}

src_install() {                               

    cd $S
    exeinto /opt/cvsup
    doexe cvsup*
    
    dodoc License
    
    insinto /etc/env.d
    doins $FILESDIR/99cvsup

}
