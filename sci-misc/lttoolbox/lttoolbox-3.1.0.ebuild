# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/lttoolbox/lttoolbox-3.1.0.ebuild,v 1.2 2010/05/07 04:03:17 jer Exp $

DESCRIPTION="lttoolbox is a toolbox for lexical processing, morphological analysis and generation of words"
HOMEPAGE="http://apertium.sourceforge.net"
SRC_URI="mirror://sourceforge/apertium/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-libs/libxml2
		dev-libs/libxslt
		dev-libs/libpcre
		sys-libs/libunwind"
RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc README AUTHORS ChangeLog || die "dodoc failed"
}
