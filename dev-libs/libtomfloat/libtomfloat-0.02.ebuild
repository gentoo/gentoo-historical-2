# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtomfloat/libtomfloat-0.02.ebuild,v 1.4 2008/06/10 03:09:59 darkside Exp $

DESCRIPTION="library for floating point number manipulation"
HOMEPAGE="http://libtom.org/"
SRC_URI="http://libtom.org/files/ltf-${PV}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=""

src_install() {
	make install DESTDIR="${D}" || die
	dodoc changes.txt *.pdf WARNING
	docinto demos ; dodoc demos/*
}
