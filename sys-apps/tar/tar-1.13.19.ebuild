# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tar/tar-1.13.19.ebuild,v 1.3 2002/07/11 06:30:55 drobbins Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}

DESCRIPTION="Use this to try make tarballs :)"
SRC_URI="ftp://alpha.gnu.org/gnu/tar/"${A}
HOMEPAGE="http://www.gnu.org/software/tar/"

DEPEND="virtual/glibc
        nls? ( >=sys-devel/gettext-0.10.35 )"

RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}/src
	patch -p0 < ${FILESDIR}/tar-1.13.19.patch
}

src_compile() {

    local myconf
    if [ -z "`use nls`" ]
    then
        myconf="--disable-nls"
    fi
	try ./configure --prefix=/usr --bindir=/bin --libexecdir=/usr/lib/misc \
        --infodir=/usr/share/info --host=${CHOST} ${myconf}

    if [ -z "`use static`" ]
    then
	    try make ${MAKEOPTS}
    else
        try make ${MAKEOPTS} LDFLAGS=-static
    fi
}

src_install() {
	try make DESTDIR=${D} install
	#FHS 2.1 stuff
	dodir /usr/sbin
	cd ${D}
	mv usr/lib/misc/rmt usr/sbin/rmt.gnu
	dosym rmt.gnu /usr/sbin/rmt
    if [ -z "`use build`" ]
    then
	    dodoc AUTHORS ChangeLog* COPYING NEWS README* PORTS THANKS

	    #we're using Schilly's enhanced rmt command included with star
#	    rm -rf ${D}/usr/lib
    else
        rm -rf ${D}/usr/share/info
    fi
	
}


