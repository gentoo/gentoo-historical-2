# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Justin Lambert <jlambert@eml.cc>>
# /space/gentoo/cvsroot/gentoo-x86/app-misc/dailystrips/dailystrips-1.0.24.ebuild,v 1.3 2002/05/27 17:27:35 drobbins Exp

DESCRIPTION="dailystrips automatically downloads your favorite online comics from the web."
HOMEPAGE="http://dailystrips.sourceforge.net/"

DEPEND=">=dev-perl/libwww-perl-5.50"

#SRC_URI="mirror://sourceforge/dailystrips/${P}.tar.gz"
SRC_URI="http://west.dl.sourceforge.net/sourceforge/dailystrips/${P}.tar.gz"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cd ${S}
	cp dailystrips dailystrips.orig
	sed -e "s:/usr/share/dailystrips/strips.def:/etc/strips.def:" \
		dailystrips.orig > dailystrips
}

src_install() {
	dobin dailystrips
	dobin dailystrips-clean
	dodoc README BUGS CHANGELOG TODO

	keepdir /etc
	insinto /etc
	doins strips.def
}
