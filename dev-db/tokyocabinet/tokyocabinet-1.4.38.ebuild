# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/tokyocabinet/tokyocabinet-1.4.38.ebuild,v 1.1 2009/11/10 13:59:52 patrick Exp $

EAPI=2

inherit eutils

DESCRIPTION="A library of routines for managing a database"
HOMEPAGE="http://1978th.net/tokyocabinet/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~x86 ~x86-fbsd ~ppc-macos ~x64-solaris"
IUSE="debug doc examples"

DEPEND="sys-libs/zlib
	app-arch/bzip2"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/fix_rpath.patch"
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	if use examples; then
		dodoc example/* || die "Install failed"
	fi

	if use doc; then
		dodoc doc/* || die "Install failed"
	fi
}

src_test() {
	emake -j1 check || die "Tests failed"
}
