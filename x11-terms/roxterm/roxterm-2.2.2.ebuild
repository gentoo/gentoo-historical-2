# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/roxterm/roxterm-2.2.2.ebuild,v 1.4 2011/11/11 09:23:34 phajdan.jr Exp $

EAPI=4
inherit flag-o-matic gnome2-utils

DESCRIPTION="A terminal emulator designed to integrate with the ROX environment"
HOMEPAGE="http://roxterm.sourceforge.net/"
SRC_URI="mirror://sourceforge/roxterm/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-libs/dbus-glib
	>=dev-libs/glib-2.16
	x11-libs/gtk+:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/vte:2.90"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	sed -i -e 's:TerminalEmulator:System;&:' roxterm.desktop || die
}

src_configure() {
	append-flags -fno-strict-aliasing
	econf --htmldir=/usr/share/doc/${PF}/html
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
