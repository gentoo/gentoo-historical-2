# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/hnb/hnb-1.9.17.ebuild,v 1.7 2004/07/13 22:02:56 agriffis Exp $

DESCRIPTION="hnb is a program to organize many kinds of data in one place, including addresses, TODO lists, ideas, book reviews, brainstorming, speech outlines, etc. It stores data in XML format, and is capable of native export to ASCII and HTML."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://hnb.sourceforge.net/"

SLOT="0"
LICENSE="GPL-1"
KEYWORDS="x86 ~ppc ~sparc"
IUSE=""

DEPEND=""

src_compile() {
	make || die
}

src_install() {
	dodoc README doc/hnbrc
	doman doc/hnb.1
	dobin src/hnb
}
