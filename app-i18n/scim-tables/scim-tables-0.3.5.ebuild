# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-tables/scim-tables-0.3.5.ebuild,v 1.7 2005/01/01 14:39:46 eradicator Exp $

DESCRIPTION="Smart Common Input Method (SCIM) Generic Table Input Method Server"
HOMEPAGE="http://freedesktop.org/~suzhe/"
SRC_URI="http://freedesktop.org/~suzhe/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

DEPEND=">=app-i18n/scim-0.9.6
	!>=app-i18n/scim-0.99"

src_compile() {
	econf || die "econf failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc README ChangeLog AUTHORS
}
