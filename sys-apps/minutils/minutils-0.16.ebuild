# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/minutils/minutils-0.16.ebuild,v 1.2 2004/06/24 22:16:56 agriffis Exp $

DESCRIPTION="additional tools for embedded systems"
HOMEPAGE="http://www.skarnet.org/software/minutils/"
SRC_URI="http://www.skarnet.org/software/minutils/${P}.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-libs/skalibs"
#RDEPEND=""
S=${WORKDIR}/host/skarnet.org/${P}

src_compile() {
	package/install
}

src_install() {
	insinto /sbin
	doins command/*

	dohtml doc/*.html
}
