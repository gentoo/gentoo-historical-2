# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/rkward/rkward-0.5.1.ebuild,v 1.2 2009/10/30 19:35:44 maekke Exp $

EAPI="2"
KDE_MINIMAL="4.1"

inherit kde4-base

DESCRIPTION="An IDE/GUI for the R-project"
HOMEPAGE="http://rkward.sourceforge.net/"
SRC_URI="mirror://sourceforge/rkward/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND=">=dev-lang/R-2.7.0
		dev-lang/php[cli]"
RDEPEND="${DEPEND}
	!<=sci-mathematics/rkward-0.5.0b"

src_install() {
	kde4-base_src_install
	# avoid file collisions
	rm -f "${D}"/usr/$(get_libdir)/R/library/R.css
	rm -f "${D}"/usr/share/apps/katepart/syntax/r.xml
}
