# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-hangul/scim-hangul-0.3.0.ebuild,v 1.1 2006/11/04 06:16:51 matsuu Exp $

DESCRIPTION="Hangul IMEngine for SCIM ported from imhangul"
HOMEPAGE="http://www.scim-im.org/"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde nls"

RDEPEND="|| ( >=app-i18n/scim-0.99.8 >=app-i18n/scim-cvs-0.99.8 )
	>=app-i18n/libhangul-0.0.3
	kde? ( app-i18n/skim )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_compile() {
	econf \
		$(use_enable kde skim-support) \
		$(use_enable nls) || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog NEWS README*
}

pkg_postinst() {
	einfo
	einfo "To use SCIM with both GTK2 and XIM, you should use the following"
	einfo "in your user startup scripts such as .gnomerc or .xinitrc:"
	einfo
	einfo "LANG='your_language' scim -d"
	einfo "export XMODIFIERS=@im=SCIM"
	einfo
}
