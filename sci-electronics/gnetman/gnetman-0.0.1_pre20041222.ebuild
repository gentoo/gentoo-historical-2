# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gnetman/gnetman-0.0.1_pre20041222.ebuild,v 1.2 2005/02/17 23:27:51 hansmi Exp $

MY_PV="22Dec04"

DESCRIPTION="gnetman - A GNU Netlist Manipulation Library"
SRC_URI="http://www.viasic.com/opensource/gnetman-${MY_PV}.tar.gz"
HOMEPAGE="http://www.viasic.com/opensource/"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

S="${WORKDIR}/${PN}-${MY_PV}"

DEPEND=">=dev-lang/tk-8.3"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README
}
