# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/console-tools/console-tools-0.2.3-r4.ebuild,v 1.15 2003/02/13 15:50:44 vapier Exp $

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="Console and font utilities"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/system/keyboards/${P}.tar.gz"
HOMEPAGE="http://altern.org/ydirson/en/lct/"
KEYWORDS="x86 ppc sparc ~alpha"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc
	sys-devel/autoconf sys-devel/automake sys-devel/libtool
	nls? ( sys-devel/gettext )"
RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/${P}.patch || die
	patch -p0 < ${FILESDIR}/${P}-po-Makefile.in.in-gentoo.diff || die
	aclocal || die
	libtoolize --force -c || die
	autoheader || die
	automake -c || die
	autoconf || die
}

src_compile() {
	local myconf=""
	[ "$DEBUG" ] && myconf="--enable-debugging"
	[ -z "`use nls`" ] && myconf="${myconf} --disable-nls"

	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--host=${CHOST} \
		${myconf} || die
	make $MAKEOPTS all || die
}

src_install() {
	# DESTDIR does not work correct
	make DESTDIR=${D} install || die

	dodoc BUGS COPYING* CREDITS ChangeLog NEWS README RELEASE TODO
	docinto txt
	dodoc doc/*.txt doc/README.*
	docinto sgml
	dodoc doc/*.sgml
	docinto txt/contrib
	dodoc doc/contrib/*
	docinto txt/dvorak
	dodoc doc/dvorak/*
	docinto txt/file-formats
	dodoc doc/file-formats/*
	doman doc/man/*.[1-8]
}
