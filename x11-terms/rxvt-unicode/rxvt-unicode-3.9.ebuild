# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/rxvt-unicode/rxvt-unicode-3.9.ebuild,v 1.2 2004/09/02 16:47:28 pvdabeel Exp $

IUSE="xgetdefault"

DESCRIPTION="rxvt clone with XFT and Unicode support"
HOMEPAGE="http://www.sourceforge.net/projects/rxvt-unicode/"
SRC_URI="http://rxvt-unicode-dist.plan9.de/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~mips ~amd64 ppc"

DEPEND="virtual/libc
	virtual/x11
	app-text/yodl"

src_unpack() {
	unpack ${A}
	cd ${S}
	local tdir=/usr/share/terminfo
	sed -i -e \
		"s~@TIC@ \(etc/rxvt\)~@TIC@ -o ${D}/${tdir} \1~" \
		doc/Makefile.in
}

src_compile() {
	econf \
		--enable-everything \
		--enable-rxvt-scroll \
		--enable-next-scroll \
		--enable-xterm-scroll \
		--enable-transparency \
		--enable-xpm-background \
		--enable-fading \
		--enable-utmp \
		--enable-wtmp \
		--enable-mousewheel \
		--enable-slipwheeling \
		--enable-smart-resize \
		--enable-ttygid \
		--enable-256-color \
		--enable-xim \
		--enable-shared \
		--enable-keepscrolling \
		--enable-xft \
		`use_enable xgetdefault` \
		--disable-text-blink \
		--disable-menubar || die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc README.unicode Changes
	cd ${S}/doc
	dodoc README* changes.txt BUGS TODO etc/*
}

pkg_postinst() {
	einfo "urxvt now always uses TERM=rxvt-unicode so that the"
	einfo "upstream-supplied terminfo files can be used."
}
