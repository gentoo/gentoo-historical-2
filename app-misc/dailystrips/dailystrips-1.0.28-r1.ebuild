# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/dailystrips/dailystrips-1.0.28-r1.ebuild,v 1.4 2005/01/01 14:57:44 eradicator Exp $

DESCRIPTION="dailystrips automatically downloads your favorite online comics from the web."
HOMEPAGE="http://dailystrips.sourceforge.net/"
SRC_URI="mirror://sourceforge/dailystrips/${P}.tar.gz"

KEYWORDS="x86 alpha ppc"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=dev-perl/libwww-perl-5.50"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e "s:/usr/share/dailystrips/strips.def:/etc/strips.def:" \
		dailystrips || die "sed dailystrips failed"
}

src_install() {
	dobin dailystrips dailystrips-clean dailystrips-update \
		|| die "dobin failed"
	dodoc README BUGS CHANGELOG TODO || die "dodoc failed"

	insinto /etc
	doins strips.def || die "doins failed"
}
