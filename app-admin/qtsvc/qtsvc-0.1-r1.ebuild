# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Your Name <your email>
# $Header: /var/cvsroot/gentoo-x86/app-admin/qtsvc/qtsvc-0.1-r1.ebuild,v 1.4 2002/02/03 21:56:01 danarmak Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A QT frontend for svc"
SRC_URI="http://www.together.net/~plomp/${P}.tar.gz"
HOMEPAGE="http://www.together.net/~plomp/qtsvc.html"

DEPEND="=x11-libs/qt-2*"
RDEPEND="$DEPEND
	 >=sys-apps/daemontools-0.70"

src_unpack() {

    unpack ${A}
    cd ${S}
    patch -p0 < ${FILESDIR}/qtsvc-0.1.diff
}

src_compile() {

    QTDIR=/usr/qt/2 ./configure --host=${CHOST} || die
    #make CPPFLAGS=\"${CPPFLAGS} -fkeep-inline-functions\" || die
    make || die

}

src_install () {

    into /usr
    dobin qtsvc/qtsvc    
    dodoc README qtsvc/MANUAL qtsvc/LICENSE qtsvc/PROGRAMMING

}

