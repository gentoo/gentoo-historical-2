# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/kbd/kbd-1.12-r1.ebuild,v 1.2 2004/02/23 00:44:20 agriffis Exp $

IUSE="nls"

inherit eutils

S="${WORKDIR}/${P}"
DESCRIPTION="Keyboard and console utilities"
SRC_URI="ftp://ftp.cwi.nl/pub/aeb/kbd/${P}.tar.gz
	ftp://ftp.win.tue.nl/pub/home/aeb/linux-local/utils/kbd/${P}.tar.gz"
HOMEPAGE="http://freshmeat.net/projects/kbd/"

KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha ~mips ~hppa ~ia64 ~ppc64"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc nls? ( sys-devel/gettext )"
PROVIDE="sys-apps/console-tools"

src_unpack() {
	unpack ${A}

	cd ${S}
	# Fixes makefile so that it uses the CFLAGS from portage (bug #21320).
	sed -i -e "s:-O2:${CFLAGS}:g" src/Makefile.in

	# Other patches from RH
	epatch ${FILESDIR}/${PN}-1.08-terminal.patch

	# Fixes a problem where loadkeys matches dvorak the dir, and not the
	# .map inside
	epatch ${FILESDIR}/${P}-find-map-fix.patch

	# Sparc have not yet fixed struct kbd_rate to use 'period' and not 'rate'.
	epatch ${FILESDIR}/${P}-kbd_repeat.patch
}

src_compile() {
	local myconf=

	# Non-standard configure script; --disable-nls to
	# disable NLS, nothing to enable it.
	use nls || myconf="--disable-nls"

	# We should not add the prefix to mandir and datadir
	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--datadir=/usr/share \
		${myconf} || die

	make || die
}

src_install() {
	make \
		DESTDIR=${D} \
		DATADIR=${D}/usr/share \
		MANDIR=${D}/usr/share/man \
		install || die

	mv ${D}/usr/bin/setfont ${D}/bin/
	dosym ../../bin/setfont /usr/bin/setfont

	dodoc CHANGES CREDITS COPYING README
	dodir /usr/share/doc/${PF}/html
	cp -dR doc/* ${D}/usr/share/doc/${PF}/html/
}

