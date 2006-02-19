# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cdk/cdk-5.0.20051230.ebuild,v 1.1 2006/02/19 18:01:35 vanquirius Exp $

inherit flag-o-matic

MY_P="${P/.200/-200}"
DESCRIPTION="A library of curses widgets"
HOMEPAGE="http://dickey.his.com/cdk/cdk.html"
SRC_URI="ftp://invisible-island.net/cdk/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.2
	sys-devel/libtool"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PN}-5.0-20051230-include.patch
}

src_compile() {
	# libcdk.a is linked into a shared object in licq
	append-flags -fPIC

	econf \
		--with-ncurses --with-libtool \
		|| die

	emake || die
}


src_install() {
	make \
		DESTDIR="${D}" \
		DOCUMENT_DIR="${D}/usr/share/doc/${MY_P}" install \
		|| die
}
