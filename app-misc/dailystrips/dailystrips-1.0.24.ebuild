# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/dailystrips/dailystrips-1.0.24.ebuild,v 1.7 2002/10/19 15:48:49 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="dailystrips automatically downloads your favorite online comics from the web."
HOMEPAGE="http://dailystrips.sourceforge.net/"
SRC_URI="mirror://sourceforge/dailystrips/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=dev-perl/libwww-perl-5.50"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp dailystrips dailystrips.orig
	sed -e "s:/usr/share/dailystrips/strips.def:/etc/strips.def:" \
		dailystrips.orig > dailystrips
}

src_install() {
	dobin dailystrips
	dodoc README BUGS CHANGELOG TODO

	keepdir /etc
	insinto /etc
	doins strips.def
}
