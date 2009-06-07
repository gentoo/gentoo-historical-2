# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libcddb/libcddb-1.3.2.ebuild,v 1.4 2009/06/07 16:57:23 nixnut Exp $

EAPI=2
inherit libtool

DESCRIPTION="A library for accessing a CDDB server"
HOMEPAGE="http://libcddb.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="virtual/libiconv"
DEPEND="doc? ( app-doc/doxygen )"

RESTRICT="test"

src_prepare() {
	# needed for sane .so versionning on FreeBSD
	elibtoolize
}

src_configure() {
	econf --without-cdio
}

src_compile() {
	emake || die "emake failed."

	# Create API docs if needed and possible
	if use doc; then
		cd doc
		doxygen doxygen.conf || die "doxygen failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO

	# Create API docs if needed and possible
	use doc && dohtml doc/html/*
}
