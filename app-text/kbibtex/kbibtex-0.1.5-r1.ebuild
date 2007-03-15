# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/kbibtex/kbibtex-0.1.5-r1.ebuild,v 1.2 2007/03/15 08:53:41 cryos Exp $

inherit kde eutils

DESCRIPTION="BibTeX editor for KDE"
HOMEPAGE="http://www.unix-ag.uni-kl.de/~fischer/kbibtex/"
SRC_URI="http://www.unix-ag.uni-kl.de/~fischer/kbibtex/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/libxml2-2.6.22
	>=dev-libs/libxslt-1.1.15"
RDEPEND="${DEPEND}
	virtual/tetex
	>=dev-tex/bibtex2html-1.70"

need-kde 3.3

PATCHES="${FILESDIR}/kbibtex-0.1.5-viewdocument.patch
	${FILESDIR}/kbibtex-0.1.5-compile-fix.patch"
