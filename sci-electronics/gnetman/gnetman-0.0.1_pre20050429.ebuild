# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gnetman/gnetman-0.0.1_pre20050429.ebuild,v 1.1.1.1 2005/11/30 09:51:05 chriswhite Exp $

MY_PV="29Apr05"

DESCRIPTION="gnetman - A GNU Netlist Manipulation Library"
SRC_URI="http://www.viasic.com/opensource/gnetman-${MY_PV}.tar.gz"
HOMEPAGE="http://www.viasic.com/opensource/"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc ~x86"

S="${WORKDIR}/${PN}-${MY_PV}"

DEPEND=">=dev-lang/tk-8.3"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README
}
