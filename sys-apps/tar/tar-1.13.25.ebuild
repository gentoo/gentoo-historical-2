# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tar/tar-1.13.25.ebuild,v 1.4 2001/12/27 20:54:29 woodchip Exp $

S=${WORKDIR}/${P}

DESCRIPTION="Use this to try make tarballs :)"
SRC_URI="ftp://alpha.gnu.org/gnu/tar/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/tar/"

DEPEND="virtual/glibc nls? ( sys-devel/gettext-0.10.35 )"

RDEPEND="virtual/glibc"

src_compile() {
	local myconf
	[ -z "`use nls`" ] && myconf="--disable-nls"
	./configure --prefix=/usr --bindir=/bin --libexecdir=/usr/lib/misc \
	--infodir=/usr/share/info --host=${CHOST} ${myconf} || die
	if [ -z "`use static`" ]
	then
		emake || die
	else
		emake LDFLAGS=-static || die
	fi
}

src_install() {
	make DESTDIR=${D} install || die
	#FHS 2.1 stuff
	dodir /usr/sbin
	cd ${D}
	mv usr/lib/misc/rmt usr/sbin/rmt.gnu
	dosym rmt.gnu /usr/sbin/rmt
	if [ -z "`use build`" ] 
	then
		dodoc AUTHORS ChangeLog* COPYING NEWS README* PORTS THANKS
	else
		rm -rf ${D}/usr/share
	fi
}
