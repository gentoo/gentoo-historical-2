# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/flac/flac-1.1.1.ebuild,v 1.4 2004/10/05 18:33:30 lu_zero Exp $

IUSE="sse xmms"

inherit libtool eutils flag-o-matic gcc

DESCRIPTION="free lossless audio encoder which includes an XMMS plugin"
HOMEPAGE="http://flac.sourceforge.net/"
SRC_URI="mirror://sourceforge/flac/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2 "
SLOT="0"
KEYWORDS="~x86 -ppc ~sparc ~mips ~alpha ~hppa ~amd64 ~ia64 ~ppc64"

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
		sed -i -e '/^@FLaC__HAS_XMMS_TRUE/d' src/Makefile.in || die
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
	make DESTDIR="${D}" install || die
	dodoc AUTHORS README

	# Keep around old lib
	preserve_old_lib /usr/$(get_libdir)/libFLAC.so.4
	preserve_old_lib /usr/$(get_libdir)/libFLAC++.so.2
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libFLAC.so.4
	preserve_old_lib_notify /usr/$(get_libdir)/libFLAC++.so.2
}

