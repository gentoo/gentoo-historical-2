# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/rxvt-unicode/rxvt-unicode-4.8.ebuild,v 1.3 2005/02/27 00:13:26 latexer Exp $

inherit 64-bit eutils

IUSE="xgetdefault"

DESCRIPTION="rxvt clone with XFT and Unicode support"
HOMEPAGE="http://software.schmorp.de/"
SRC_URI="http://rxvt-unicode-dist.plan9.de/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~mips ~amd64 ppc"

DEPEND="virtual/libc
	dev-util/pkgconfig
	sys-devel/libtool
	virtual/x11
	dev-lang/perl"

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

	dodoc README.FAQ Changes
	cd ${S}/doc
	dodoc README* changes.txt etc/*
}

pkg_postinst() {
	einfo "urxvt now always uses TERM=rxvt-unicode so that the"
	einfo "upstream-supplied terminfo files can be used."
}
