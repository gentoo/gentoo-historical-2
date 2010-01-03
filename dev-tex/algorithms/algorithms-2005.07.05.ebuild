# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/algorithms/algorithms-2005.07.05.ebuild,v 1.4 2010/01/03 11:25:03 fauli Exp $

inherit latex-package

DESCRIPTION="algorithms -- an environment for describing algorithms"
HOMEPAGE="http://algorithms.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P//\./-}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

# tetex-3.0 includes algorithms
DEPEND="!>=app-text/tetex-3.0"
S="${WORKDIR}/${PN}"

src_install() {
	latex-package_src_install || die
	dodoc README THANKS
}
