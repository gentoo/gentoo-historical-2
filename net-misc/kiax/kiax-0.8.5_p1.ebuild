# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/kiax/kiax-0.8.5_p1.ebuild,v 1.2 2006/06/22 05:42:38 tsunam Exp $

inherit eutils kde-functions

IUSE=""

MY_P="${P/_p/}"

DESCRIPTION="QT based IAX (Inter Asterisk eXchange) client"
HOMEPAGE="http://kiax.sourceforge.net/"
SRC_URI="mirror://sourceforge/kiax/${MY_P}-src.tar.gz"

KEYWORDS="~amd64 x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="$(qt_min_version 3.2)"

S="${WORKDIR}/${MY_P}-src"

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
	make INSTALL_ROOT="${D}" install || die "make install failed"

	domenu kiax.desktop
	dodoc README README.* CHANGELOG COPYING INSTALL INSTALL.*
}
