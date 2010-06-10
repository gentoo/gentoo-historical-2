# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libvpx/libvpx-9999.ebuild,v 1.2 2010/06/10 16:02:38 lu_zero Exp $

EAPI=2
inherit eutils multilib toolchain-funcs git

EGIT_REPO_URI="git://review.webmproject.org/${PN}.git"

DESCRIPTION="WebM VP8 Codec SDK"
HOMEPAGE="http://www.webmproject.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="debug doc postproc +threads"

RDEPEND=""
DEPEND="dev-lang/yasm
	doc? (
		app-doc/doxygen
		dev-lang/php
	)
"

src_configure() {
	tc-export CC
	./configure \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--enable-pic \
		--enable-vp8 \
		--enable-shared \
		$(use_enable debug) \
		$(use_enable debug debug-libs) \
		$(use_enable doc install-docs) \
		$(use_enable postproc) \
		$(use_enable threads multithread) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS CHANGELOG README || die
}
