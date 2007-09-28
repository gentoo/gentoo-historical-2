# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-uim/scim-uim-0.2.0.ebuild,v 1.4 2007/09/28 20:17:59 philantrop Exp $

DESCRIPTION="scim-uim is an input module for Smart Common Input Method (SCIM) which uses uim as backend"
HOMEPAGE="http://www.scim-im.org/"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

RDEPEND=">=app-i18n/uim-1.1.0
	|| (
		>=app-i18n/scim-1.4.0
		>=app-i18n/scim-cvs-1.4.0
	)"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog README THANKS
}

pkg_postinst() {
	elog
	elog "To use SCIM with both GTK2 and XIM, you should use the following"
	elog "in your user startup scripts such as .gnomerc or .xinitrc:"
	elog
	elog "LANG='your_language' scim -d"
	elog "export XMODIFIERS=@im=SCIM"
	elog
}
