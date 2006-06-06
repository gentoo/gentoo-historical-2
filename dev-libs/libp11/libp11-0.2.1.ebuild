# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libp11/libp11-0.2.1.ebuild,v 1.2 2006/06/06 18:44:14 dertobi123 Exp $

DESCRIPTION="Libp11 is a library implementing a small layer on top of PKCS#11 API
to make using PKCS#11 implementations easier."
HOMEPAGE="http://www.opensc-project.org/libp11/"
SRC_URI="http://www.opensc-project.org/files/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dohtml doc/*.html doc/*.css
}

