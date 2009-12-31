# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/gtkimprime/gtkimprime-0.1.ebuild,v 1.4 2009/12/31 21:07:07 ssuominen Exp $

DESCRIPTION="Yet another PRIME client for GTK+2"
HOMEPAGE="http://gtkimprime.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/gtkimprime/12368/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.4
	>=app-i18n/prime-0.9.2-r1"

get_gtk_confdir() {
	if useq amd64 || ( [ "${CONF_LIBDIR}" == "lib32" ] && useq x86 ) ; then
		echo "/etc/gtk-2.0/${CHOST}"
	else
		echo "/etc/gtk-2.0"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog README
}

pkg_postinst() {
	gtk-query-immodules-2.0 > "${ROOT}$(get_gtk_confdir)/gtk.immodules"
}

pkg_postrm() {
	gtk-query-immodules-2.0 > "${ROOT}$(get_gtk_confdir)/gtk.immodules"
}
