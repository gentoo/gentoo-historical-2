# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/silky/silky-0.5.1.ebuild,v 1.4 2004/07/07 22:23:01 swegener Exp $

IUSE="debug"

DESCRIPTION="Simple and easy to use GTK+ based os-independent SILC client."
HOMEPAGE="http://silky.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
KEYWORDS="x86 ~ppc ~sparc"
LICENSE="GPL-2"

SLOT="0"

DEPEND="virtual/libc
	sys-libs/zlib
	>=gnome-base/libglade-2
	>=x11-libs/gtk+-2.2
	x11-libs/pango
	dev-libs/atk
	>=dev-libs/glib-2.2
	dev-libs/libxml2
	app-misc/mime-types
	>=net-im/silc-toolkit-0.9.12-r2"

src_compile() {
	econf \
		--with-silc-includes=/usr/include/silc-toolkit \
		--with-silc-libs=/usr/lib \
		$(use_enable debug) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
}
