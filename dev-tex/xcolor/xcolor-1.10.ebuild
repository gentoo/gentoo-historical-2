# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/xcolor/xcolor-1.10.ebuild,v 1.1 2004/04/21 14:30:32 usata Exp $

inherit latex-package

DESCRIPTION="xcolor -- easy driver-independent access to colors"
HOMEPAGE="http://latex-beamer.sourceforge.net/"
SRC_URI="mirror://sourceforge/latex-beamer/${P}.tar.gz"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

IUSE=""

DEPEND="virtual/tetex"
S="${WORKDIR}/${PN}"

src_install() {

	addwrite /var/cache/fonts/

	latex-package_src_install || die

	dodoc README
}
