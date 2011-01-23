# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/odt2txt/odt2txt-0.4-r1.ebuild,v 1.2 2011/01/23 13:55:10 hwoarang Exp $

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="A simple converter from OpenDocument Text to plain text"
HOMEPAGE="http://stosberg.net/odt2txt/"
SRC_URI="http://stosberg.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~sparc ~x86 ~x86-macos"
IUSE=""

RDEPEND="sys-libs/zlib
	virtual/libiconv"
DEPEND="sys-apps/groff
	${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-darwin_iconv.patch
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake install DESTDIR="${D}" PREFIX=/usr || die
	doman odt2txt.1 || die
}
