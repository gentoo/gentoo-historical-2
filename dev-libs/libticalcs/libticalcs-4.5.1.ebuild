# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libticalcs/libticalcs-4.5.1.ebuild,v 1.4 2004/04/26 01:17:25 agriffis Exp $

DESCRIPTION="libticalcs is a necessary library for the TiLP calculator linking program."
HOMEPAGE="http://tilp.sourceforge.net/"
SRC_URI="mirror://sourceforge/tilp/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND="dev-libs/libticables
		dev-libs/libtifiles"

src_compile() {
	econf || die "econf failed"
	emake || die
}

src_install() {
	einstall aclocaldir=${D}/usr/share/aclocal || die
}
