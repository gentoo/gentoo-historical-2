# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/rcs/rcs-5.7.ebuild,v 1.1 2000/08/30 13:04:24 achim Exp $

P=rcs-5.7
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Revision Controll System"
SRC_URI="ftp://ftp.gnu.org/gnu/rcs/${A}"
HOMEPAGE="http://www.gnu.org/software/rcs/"


src_compile() {

    cd ${S}
    ./configure --prefix=/usr --host=${CHOST} --with-diffutils
    cp ${FILESDIR}/conf.sh src/conf.sh
    make

}

src_install () {

    cd ${S}
    make prefix=${D}/usr install
    prepman
    dodoc ChangeLog COPYING CREDITS NEWS README REFS
}

