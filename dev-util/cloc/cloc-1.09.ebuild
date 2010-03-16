# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cloc/cloc-1.09.ebuild,v 1.1 2010/03/16 21:42:37 ssuominen Exp $

DESCRIPTION="Count Lines of Code"
HOMEPAGE="http://cloc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.pl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6"

src_unpack() { :; }

src_install() {
	newbin "${DISTDIR}"/${P}.pl ${PN} || die
}
