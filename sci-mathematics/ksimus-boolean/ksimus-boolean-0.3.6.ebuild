# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/ksimus-boolean/ksimus-boolean-0.3.6.ebuild,v 1.3 2005/05/27 11:24:40 phosphan Exp $

inherit kde eutils

MYPATCH="${PN}-${PV}-namespaces.patch"
HOMEPAGE="http://ksimus.berlios.de/"
DESCRIPTION="The package Boolean contains some boolean components for KSimus."
KEYWORDS="x86"
SRC_URI="http://ksimus.berlios.de/download/${PN}-3-${PV}.tar.gz
		mirror://gentoo/${MYPATCH}.bz2"

LICENSE="GPL-2"
IUSE=""
SLOT="0"

DEPEND="sci-mathematics/ksimus"

need-kde 3

src_unpack() {
	unpack ${A}
	unpack ${MYPATCH}.bz2
	cd ${S}
	epatch ${WORKDIR}/${MYPATCH}
}
