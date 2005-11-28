# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/xkeyval/xkeyval-1.4-r1.ebuild,v 1.1 2005/11/28 18:38:23 nattfodd Exp $

inherit latex-package

S=${WORKDIR}/${PN}

DESCRIPTION="xkeyval is an extension of the keyval package."
# Taken from: ftp://ftp.dante.de/tex-archive/macros/latex/contrib/${PN}.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"
HOMEPAGE="ftp://ftp.dante.de/tex-archive/help/Catalogue/entries/xkeyval.html"
LICENSE="LPPL-1.2"
DEPEND="!>=app-text/tetex-3.0"

IUSE=""
SLOT="0"
KEYWORDS="x86 ~amd64 ppc"

src_install() {
	insinto /usr/share/texmf/tex/latex/${PN}
	doins ${S}/run/latex/* ${S}/run/tex/*

	dodoc README
	insinto /usr/share/doc/${PF}
	doins doc/*
}
