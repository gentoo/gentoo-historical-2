# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/calcurse/calcurse-1.8.ebuild,v 1.2 2007/09/22 20:25:10 philantrop Exp $

DESCRIPTION="a text-based personal organizer"
HOMEPAGE="http://culot.org/calcurse/index.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="linguas_en linguas_fr linguas_de linguas_es"

DEPEND="sys-libs/ncurses"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm po/LINGUAS
}

src_compile() {
	local ALL_LINGUAS=""

	use linguas_en && ALL_LINGUAS="${ALL_LINGUAS} en"
	use linguas_fr && ALL_LINGUAS="${ALL_LINGUAS} fr"
	use linguas_de && ALL_LINGUAS="${ALL_LINGUAS} de"
	use linguas_es && ALL_LINGUAS="${ALL_LINGUAS} es"

	ALL_LINGUAS="${ALL_LINGUAS}" econf || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
	dohtml doc/*.html
}
