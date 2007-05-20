# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/catdvi/catdvi-0.14.ebuild,v 1.1 2007/05/20 17:16:49 ulm Exp $

DESCRIPTION="DVI to plain text translator"
HOMEPAGE="http://catdvi.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/tetex"
RDEPEND="${DEPEND}"

src_compile() {
	econf || die "econf failed"
	# Do not use plain emake here, because make tests
	# may cache fonts and generate sandbox violations.
	emake catdvi || die "emake failed"
}

src_install() {
	dobin catdvi
	doman catdvi.1
	dodoc AUTHORS ChangeLog NEWS README TODO
}
