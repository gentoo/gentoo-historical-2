# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/geda-xgsch2pcb/geda-xgsch2pcb-0.1.3-r2.ebuild,v 1.1 2011/01/30 07:39:53 tomjbe Exp $

EAPI="2"

WANT_AUTOCONF="2.5"
PYTHON_DEPEND="2"

inherit autotools eutils fdo-mime gnome2-utils python

DESCRIPTION="A graphical front-end for the gschem -> pcb workflow"
HOMEPAGE="http://www.gpleda.org/tools/xgsch2pcb/index.html"
SRC_URI="http://geda.seul.org/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome nls"

CDEPEND="
	>=dev-python/pygtk-2.10
	>=dev-python/pygobject-2.10
	dev-python/dbus-python
	sci-electronics/pcb[dbus]
	sci-electronics/geda
	nls? ( virtual/libintl )"

RDEPEND="
	${CDEPEND}
	sci-electronics/electronics-menu
	gnome? ( dev-python/gnome-vfs-python )"

DEPEND="
	${CDEPEND}
	dev-util/intltool
	dev-lang/perl
	nls? ( sys-devel/gettext )"

pkg_setup() {
	python_set_active_version 2
}

src_prepare(){
	echo '#!/bin/sh' > py-compile
	epatch "${FILESDIR}"/${PV}-python.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--disable-update-desktop-database \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README ChangeLog || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	python_mod_optimize $(python_get_sitedir)/${PN}
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	python_mod_cleanup $(python_get_sitedir)/${PN}
}
