# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtifiles/libtifiles-0.5.7.ebuild,v 1.3 2004/04/26 01:18:29 agriffis Exp $

DESCRIPTION="libtifiles is a necessary library for the TiLP calculator linking program."
HOMEPAGE="http://tilp.sourceforge.net/"

SRC_URI="mirror://sourceforge/tilp/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="x86"
IUSE=""
DEPEND="dev-libs/libticables"

RDEPEND="${DEPEND}"

src_compile() {
	econf || die "econf failed"
	emake || die
}

src_install() {
	einstall aclocaldir=${D}/usr/share/aclocal || die
}
