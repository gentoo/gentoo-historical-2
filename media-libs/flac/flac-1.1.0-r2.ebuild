# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/flac/flac-1.1.0-r2.ebuild,v 1.1 2004/06/14 21:24:15 eradicator Exp $

IUSE="sse xmms"

inherit libtool eutils

DESCRIPTION="free lossless audio encoder which includes an XMMS plugin"
HOMEPAGE="http://flac.sourceforge.net/"
SRC_URI="mirror://sourceforge/flac/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~ia64 ~mips"

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

	epatch ${FILESDIR}/flac-1.1.0-m4.patch
	epatch ${FILESDIR}/flac-1.1.0-libtool.patch

	elibtoolize --reverse-deps
}

src_compile() {
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
