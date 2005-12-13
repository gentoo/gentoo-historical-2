# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cdk/cdk-4.9.10.20020809-r1.ebuild,v 1.3 2005/12/13 20:37:10 tove Exp $

inherit flag-o-matic

MY_P=${P/.2002/-2002}

S=${WORKDIR}/${MY_P}
DESCRIPTION="A library of curses widgets"
SRC_URI="ftp://invisible-island.net/cdk/${MY_P}.tgz"
HOMEPAGE="http://dickey.his.com/cdk/cdk.html"

SLOT="0"
LICENSE="BSD"
KEYWORDS="ia64 x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.2"

src_compile()
{
	append-flags -fPIC

	econf \
		--with-ncurses \
		|| die "configure failed"

	emake || die "make failed!"
}


src_install()
{
	make \
		DESTDIR=${D} \
		DOCUMENT_DIR=${D}/usr/share/doc/${MY_P} install \
		|| die "make install failed"
}
