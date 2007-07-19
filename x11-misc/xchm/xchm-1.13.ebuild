# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xchm/xchm-1.13.ebuild,v 1.5 2007/07/19 13:53:28 angelos Exp $

inherit wxwidgets flag-o-matic fdo-mime gnome2-utils

DESCRIPTION="Utility for viewing Microsoft .chm files."
HOMEPAGE="http://xchm.sf.net"
SRC_URI="mirror://sourceforge/xchm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE="nls unicode"
DEPEND=">=app-doc/chmlib-0.31
	=x11-libs/wxGTK-2.6*"
# Tested to work against a local install of 2.8.3

src_compile() {
	local myconf
	export WX_GTK_VER="2.6"

	if use unicode; then
		need-wxwidgets unicode
	else
		need-wxwidgets gtk2
	fi

	append-flags -fno-strict-aliasing

	myconf="${myconf} --with-wx-config=${WX_CONFIG}"

	econf ${myconf} \
		$(use_enable nls) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README ChangeLog

	# fixes desktop and icon problems
	rm ${D}/usr/share/pixmaps/xchm-*.xpm ${D}/usr/share/pixmaps/xchmdoc-*.xpm

	dodir /usr/share/icons/hicolor/16x16/apps/
	install -m 644 ${S}/art/xchm-16.xpm \
		${D}/usr/share/icons/hicolor/16x16/apps/xchm.xpm
	dodir /usr/share/icons/hicolor/32x32/apps/
	install -m 644 ${S}/art/xchm-32.xpm \
		${D}/usr/share/icons/hicolor/32x32/apps/xchm.xpm
	dodir /usr/share/icons/hicolor/48x48/apps/
	install -m 644 ${S}/art/xchm-48.xpm \
		${D}/usr/share/icons/hicolor/48x48/apps/xchm.xpm
	dodir /usr/share/icons/hicolor/128x128/apps/
	install -m 644 ${S}/art/xchm-128.xpm \
		${D}/usr/share/icons/hicolor/128x128/apps/xchm.xpm
	dodir /usr/share/icons/hicolor/16x16/mimetypes/
	install -m 644 ${S}/art/xchmdoc-16.xpm \
		${D}/usr/share/icons/hicolor/16x16/mimetypes/application-x-chm.xpm
	dodir /usr/share/icons/hicolor/32x32/mimetypes/
	install -m 644 ${S}/art/xchmdoc-32.xpm \
		${D}/usr/share/icons/hicolor/32x32/mimetypes/application-x-chm.xpm
	dodir /usr/share/icons/hicolor/48x48/mimetypes/
	install -m 644 ${S}/art/xchmdoc-48.xpm \
		${D}/usr/share/icons/hicolor/48x48/mimetypes/application-x-chm.xpm
	dodir /usr/share/icons/hicolor/128x128/mimetypes/
	install -m 644 ${S}/art/xchmdoc-128.xpm \
		${D}/usr/share/icons/hicolor/128x128/mimetypes/application-x-chm.xpm
	insinto /usr/share/applications
	newins ${FILESDIR}/${P}.desktop ${PN}.desktop
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
