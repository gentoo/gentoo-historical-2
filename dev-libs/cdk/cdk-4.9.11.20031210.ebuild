# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cdk/cdk-4.9.11.20031210.ebuild,v 1.6 2007/07/12 02:25:34 mr_bones_ Exp $

inherit flag-o-matic

MY_P=${P/.2003/-2003}
DESCRIPTION="A library of curses widgets"
HOMEPAGE="http://dickey.his.com/cdk/cdk.html"
SRC_URI="ftp://invisible-island.net/cdk/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.2"

S="${WORKDIR}/${MY_P}"

src_compile() {
	use ia64 && append-flags -fPIC

	econf \
		--with-ncurses \
		|| die "configure failed"

	emake || die "make failed!"
}

src_install() {
	make \
		DESTDIR=${D} \
		DOCUMENT_DIR=${D}/usr/share/doc/${MY_P} install \
		|| die "make install failed"
}
