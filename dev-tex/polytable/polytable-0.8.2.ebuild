# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/polytable/polytable-0.8.2.ebuild,v 1.3 2006/08/17 04:41:10 tsunam Exp $

inherit latex-package

DESCRIPTION="tabular-like environments with named columns"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/polytable/"
# originally from:
#SRC_URI="http://www.ctan.org/tex-archive/macros/latex/contrib/polytable/*"
SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""
DEPEND=">=dev-tex/lazylist-1.0a"
#RDEPEND=""
S="${WORKDIR}/${PN}"
