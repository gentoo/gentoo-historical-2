# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/fluxbg/fluxbg-0.7.ebuild,v 1.13 2007/07/22 04:02:33 dberkholz Exp $

DESCRIPTION="fluxbg is a tool for comfortable background changing."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://fluxbg.sourceforge.net/"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc x86"

DEPEND="x11-libs/libXt
	>=sys-devel/autoconf-2.52
	=dev-cpp/gtkmm-2.2*"

src_install () {
	make install \
	prefix=${D}/usr || die "make install failed"

	dodoc AUTHORS COPYING CREDITS INSTALL NEWS README
}
