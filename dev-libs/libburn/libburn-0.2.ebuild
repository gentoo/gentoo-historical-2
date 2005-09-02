# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libburn/libburn-0.2.ebuild,v 1.1 2005/09/02 20:54:17 metalgod Exp $

DESCRIPTION="Libburn is an open-source library for reading, mastering and
writing optical discs."
HOMEPAGE="http://icculus.org/burn/"
SRC_URI="http://icculus.org/burn/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/libc"

RDEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.12"

src_compile() {
	econf || die "Configure Failed!"
	emake || die "Make failed!"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc COPYING README TODO compile
}
