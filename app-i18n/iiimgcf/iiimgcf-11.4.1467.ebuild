# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/iiimgcf/iiimgcf-11.4.1467.ebuild,v 1.7 2004/06/30 03:29:20 agriffis Exp $

inherit iiimf eutils

DESCRIPTION="IIIMGCF is a GTK+ client framework for IIIMF"

LICENSE="LGPL-2.1"
KEYWORDS="~x86"
IUSE="gtk"

DEPEND="dev-libs/libiiimp
	dev-libs/libiiimcf
	gtk? ( =x11-libs/gtk+-2* )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog
}

pkg_postinst() {
	gtk-query-immodules-2.0 > ${ROOT}/etc/gtk-2.0/gtk.immodules
}

pkg_postrm() {
	gtk-query-immodules-2.0 > ${ROOT}/etc/gtk-2.0/gtk.immodules
}
