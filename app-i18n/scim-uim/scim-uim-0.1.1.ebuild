# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-uim/scim-uim-0.1.1.ebuild,v 1.3 2004/06/26 10:17:25 usata Exp $

DESCRIPTION="scim-uim is an input module for Smart Common Input Method (SCIM) which uses uim as backend"
HOMEPAGE="http://freedesktop.org/~suzhe/"
SRC_URI="http://freedesktop.org/~suzhe/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~alpha"
IUSE=""

DEPEND=">=app-i18n/scim-0.99.0_pre20040614
	>=app-i18n/uim-0.3.8"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc AUTHORS ChangeLog README THANKS
}

pkg_postinst() {
	einfo
	einfo "To use SCIM with both GTK2 and XIM, you should use the following"
	einfo "in your user startup scripts such as .gnomerc or .xinitrc:"
	einfo
	einfo "LANG='your_language' scim -f socket -e uim -c simple -d"
	einfo "LANG='your_language' scim -f x11 -e socket -c socket -d"
	einfo "export XMODIFIERS=@im=SCIM"
	einfo
}
