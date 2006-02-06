# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/imhangul/imhangul-0.9.12.ebuild,v 1.4 2006/02/06 06:14:07 agriffis Exp $

IUSE=""

DESCRIPTION="Gtk+-2.0 Hangul Input Modules"
HOMEPAGE="http://imhangul.kldp.net/"
SRC_URI="http://kldp.net/frs/download.php/2570/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha ~amd64 ppc x86"

DEPEND=">=x11-libs/gtk+-2.2.0"

get_gtk_confdir() {
	if useq amd64 || ( [ "${CONF_LIBDIR}" == "lib32" ] && useq x86 ) ; then
		echo "/etc/gtk-2.0/${CHOST}"
	else
		echo "/etc/gtk-2.0"
	fi
}

src_compile() {
	sed -i -e "/^moduledir/d" -e "/# moduledir/s/# //" Makefile.* || die
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}

pkg_postinst() {
	gtk-query-immodules-2.0 > ${ROOT}$(get_gtk_confdir)/gtk.immodules

	einfo ""
	einfo "If you want to use one of the module as a default input method, "
	einfo ""
	einfo "export GTK_IM_MODULE=hangul2		// 2 input type"
	einfo "export GTK_IM_MODULE=hangul3f	// 3 input type"
	einfo ""
}


pkg_postrm() {
	gtk-query-immodules-2.0 > ${ROOT}$(get_gtk_confdir)/gtk.immodules
}
