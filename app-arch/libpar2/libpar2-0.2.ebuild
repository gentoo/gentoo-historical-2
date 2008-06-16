# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/libpar2/libpar2-0.2.ebuild,v 1.5 2008/06/16 13:46:50 yngwin Exp $

DESCRIPTION="A library for par2, extracted from par2cmdline"
HOMEPAGE="http://parchive.sourceforge.net/"
SRC_URI="mirror://sourceforge/parchive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc x86"
IUSE=""

DEPEND="dev-libs/libsigc++
	dev-util/pkgconfig"
RDEPEND="dev-libs/libsigc++"

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS ChangeLog README
}
