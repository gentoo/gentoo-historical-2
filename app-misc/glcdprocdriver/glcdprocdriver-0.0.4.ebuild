# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/glcdprocdriver/glcdprocdriver-0.0.4.ebuild,v 1.2 2008/02/21 23:54:30 robbat2 Exp $

inherit multilib toolchain-funcs

DESCRIPTION="Glue library for the glcdlib LCDproc driver based on GraphLCD"
HOMEPAGE="http://www.muresan.de/graphlcd/lcdproc/"
SRC_URI="http://www.muresan.de/graphlcd/lcdproc/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86 ~ppc"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=app-misc/graphlcd-base-0.1.3"
RDEPEND=${DEPEND}

IUSE=""

src_compile() {
	emake LDFLAGS="${LDFLAGS}" CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" || die
}

src_install()
{
	emake DESTDIR="${D}/usr" LIBDIR="${D}/usr/$(get_libdir)" install || die "make install failed"
	dodoc AUTHORS README INSTALL TODO ChangeLog
}
