# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/flac/flac-1.1.0-r2.ebuild,v 1.12 2005/05/15 02:22:05 flameeyes Exp $

inherit libtool eutils flag-o-matic toolchain-funcs

DESCRIPTION="free lossless audio encoder which includes an XMMS plugin"
HOMEPAGE="http://flac.sourceforge.net/"
SRC_URI="mirror://sourceforge/flac/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="sse xmms"

RDEPEND=">=media-libs/libogg-1.0_rc2
	xmms? ( media-sound/xmms )"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )
	sys-apps/gawk"

src_unpack() {
	unpack ${A}
	cd ${S}
	if ! use xmms
	then
		cp src/Makefile.in src/Makefile.in.orig
		sed -e '/^@FLaC__HAS_XMMS_TRUE/d' src/Makefile.in.orig > src/Makefile.in || die
	fi

	epatch ${FILESDIR}/${P}-m4.patch
	epatch ${FILESDIR}/${P}-libtool.patch

	elibtoolize --reverse-deps
}

src_compile() {
	use hppa && [ "`gcc-fullversion`" == "3.4.0" ] && replace-cpu-flags 2.0 1.0

	econf \
		--with-pic \
		`use_enable sse` \
		|| die

	# the man page ebuild requires docbook2man... yick!
	sed -i -e 's:include man:include:g' Makefile

	# emake seems to mess up the building of the xmms input plugin
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
}

# see #59482
src_test() { :; }
