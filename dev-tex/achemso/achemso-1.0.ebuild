# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/achemso/achemso-1.0.ebuild,v 1.7 2004/12/28 20:57:00 absinthe Exp $

inherit latex-package
S=${WORKDIR}
DESCRIPTION="LaTeX package used for formatting publications to the American Chemical Society"
SRC_URI="http://www.homenet.se/matsd/latex/${PN}.zip"
HOMEPAGE="http://www.homenet.se/matsd/latex/"
LICENSE="LPPL-1.2" #custom, LPPL-like
SLOT="0"
IUSE=""
KEYWORDS="x86 alpha ppc ~sparc ~amd64"
DEPEND="app-arch/unzip"
