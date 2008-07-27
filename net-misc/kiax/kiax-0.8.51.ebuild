# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/kiax/kiax-0.8.51.ebuild,v 1.2 2008/07/27 22:16:26 carlo Exp $

EAPI=1

inherit eutils kde-functions

IUSE=""

DESCRIPTION="QT based IAX (Inter Asterisk eXchange) client"
HOMEPAGE="http://kiax.sourceforge.net/"
SRC_URI="mirror://sourceforge/kiax/${P}-src.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="x11-libs/qt:3"

S="${WORKDIR}/${P}-src"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/configure.patch

	# add prefix for make install
	sed -i -e "s:\(\$(DEST_PATH)\):\${INSTALL_ROOT}\1:" \
		bin/Makefile

	# fix icon/i18n prefix (bug #123839)
	sed -i -e "s:/usr/local:/usr:g" \
		src/src.pro.or
}

src_compile() {
	./configure --prefix=/usr || die "configure failed"
	emake -j1 || die "make failed"
}

src_install() {
	dodir /usr/bin
	emake INSTALL_ROOT="${D}" install || die "make install failed"

	domenu kiax.desktop
	dodoc README README.* CHANGELOG COPYING INSTALL INSTALL.*
}
