# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/patch/patch-2.5.4-r4.ebuild,v 1.11 2002/12/15 10:44:24 bjb Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Utility to apply diffs to files"
SRC_URI="ftp://ftp.gnu.org/gnu/patch/${A}"
HOMEPAGE="http://www.gnu.org/software/patch/patch.html"
DEPEND="virtual/glibc"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"

src_compile() {

	CFLAGS="$CFLAGS -DLINUX -D_XOPEN_SOURCE=500"; export CFLAGS
	try ac_cv_sys_long_file_names=yes \
		./configure --host=${CHOST} --prefix=/usr --mandir=/usr/share/man
    if [ -z "`use static`" ]
    then
	    try make ${MAKEOPTS}
    else
        try make ${MAKEOPTS} LDFLAGS=-static
    fi

}

src_install() {

	try make prefix=${D}/usr mandir=${D}/usr/share/man install
    if [ -z "`use build`" ]
    then
	    dodoc AUTHORS COPYING ChangeLog NEWS README
    else
        rm -rf ${D}/usr/share/man
    fi

}



