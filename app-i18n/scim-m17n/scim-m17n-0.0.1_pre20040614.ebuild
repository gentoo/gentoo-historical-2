# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-m17n/scim-m17n-0.0.1_pre20040614.ebuild,v 1.1 2004/06/14 17:48:57 usata Exp $

DESCRIPTION="scim-m17n is an input module for Smart Common Input Method (SCIM) which uses m17n as backend"
HOMEPAGE="http://freedesktop.org/~suzhe/"
#SRC_URI="http://freedesktop.org/~suzhe/sources/${P}.tar.gz"
SRC_URI="mirror://gentoo/${P/_pre/-}.tar.gz"

S="${WORKDIR}/${PN}-${PV/[0-9]*_pre/}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=app-i18n/scim-0.99.0_pre20040614
	>=dev-libs/m17n-lib-1.0.2-r1"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc AUTHORS THANKS README
}

pkg_postinst() {
	einfo
	einfo "To use SCIM with both GTK2 and XIM, you should use the following"
	einfo "in your user startup scripts such as .gnomerc or .xinitrc:"
	einfo
	einfo "LANG='your_language' scim -f socket -e m17n -c simple -d"
	einfo "LANG='your_language' scim -f x11 -e socket -c socket -d"
	einfo "export XMODIFIERS=@im=SCIM"
	einfo
}
