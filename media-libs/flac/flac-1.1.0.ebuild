# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/flac/flac-1.1.0.ebuild,v 1.10 2003/07/22 23:03:27 gmsoft Exp $

inherit libtool

DESCRIPTION="free lossless audio encoder which includes an XMMS plugin"
SRC_URI="mirror://sourceforge/flac/${P}.tar.gz"
HOMEPAGE="http://flac.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 ppc ~sparc alpha hppa"
IUSE="sse xmms X"

RDEPEND="virtual/glibc
	media-libs/id3lib
	>=media-libs/libogg-1.0_rc2
	X? ( xmms? ( media-sound/xmms ) )"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )
	sys-apps/gawk"

src_unpack() {
	unpack ${A}
	cd ${S}
	#if X not in use, then don't build in xmms support
	#if xmms not in use, then don't do it either.
	#if both X and xmms in use, then do it.
	if ! use xmms || ! use X
	then
		cp src/Makefile.in src/Makefile.in.orig
		sed -e '/^@FLaC__HAS_XMMS_TRUE/d' src/Makefile.in.orig > src/Makefile.in || die
	fi
}

src_compile() {
	elibtoolize --reverse-deps

	local myconf

	use sse && myconf="--enable-sse"

	econf ${myconf} || die 
	cp Makefile Makefile.orig

	#the man page ebuild requires docbook2man... yick!
	sed -e 's:include man:include:g' Makefile.orig > Makefile

	#emake seems to mess up the building of the xmms input plugin
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
}
