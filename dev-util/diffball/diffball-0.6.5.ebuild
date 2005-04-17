# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/diffball/diffball-0.6.5.ebuild,v 1.2 2005/04/17 01:29:23 ferringb Exp $

IUSE="debug"

DESCRIPTION="Delta compression suite for using/generating binary patches"
HOMEPAGE="http://developer.berlios.de/projects/diffball/"
SRC_URI="http://download.berlios.de/diffball/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc ~sparc alpha ~hppa ~mips ~amd64 ia64 ~ppc-macos"

DEPEND=">=dev-libs/openssl-0.9.6j
	>=sys-libs/zlib-1.1.4
	>=app-arch/bzip2-1.0.2"

src_compile() {
	econf $(use_enable debug asserts) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	cd ${S}
	einstall || die

	dodoc AUTHORS ChangeLog README TODO
}
