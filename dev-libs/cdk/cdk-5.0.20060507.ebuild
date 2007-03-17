# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cdk/cdk-5.0.20060507.ebuild,v 1.7 2007/03/17 17:42:27 beandog Exp $

inherit eutils versionator toolchain-funcs

MY_P="${PN}-$(replace_version_separator 2 -)"
DESCRIPTION="A library of curses widgets"
HOMEPAGE="http://dickey.his.com/cdk/cdk.html"
SRC_URI="ftp://invisible-island.net/cdk/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.2
	sys-devel/libtool"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}"/${P}-as-needed.patch
}

src_compile() {
	tc-export CC
	econf \
		--with-ncurses --with-libtool \
		|| die

	emake || die
}

src_install() {
	emake -j1 \
		DESTDIR="${D}" \
		DOCUMENT_DIR="${D}/usr/share/doc/${MY_P}" install \
		|| die
}
