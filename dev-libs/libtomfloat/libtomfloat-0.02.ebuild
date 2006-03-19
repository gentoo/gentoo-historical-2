# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtomfloat/libtomfloat-0.02.ebuild,v 1.3 2006/03/19 22:32:59 halcy0n Exp $

DESCRIPTION="library for floating point number manipulation"
HOMEPAGE="http://float.libtomcrypt.org/"
SRC_URI="http://float.libtomcrypt.org/files/ltf-${PV}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=""

src_install() {
	make install DESTDIR="${D}" || die
	dodoc changes.txt *.pdf
	docinto demo ; dodoc demo/*
}
