# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/memoir/memoir-20051006.ebuild,v 1.1 2005/10/22 10:35:30 brix Exp $

inherit latex-package

S=${WORKDIR}/${PN}

DESCRIPTION="Flexible document class"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/memoir/"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="LPPL-1.3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

IUSE=""

src_install() {
	addwrite /var/cache/fonts

	cd ${S}
	latex-package_src_install

	dodoc README
}
