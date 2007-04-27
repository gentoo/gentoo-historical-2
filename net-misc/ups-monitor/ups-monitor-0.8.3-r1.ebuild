# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ups-monitor/ups-monitor-0.8.3-r1.ebuild,v 1.1 2007/04/27 16:38:54 pva Exp $

DESCRIPTION="A UPS monitor for NUT (Network UPS Tools)"
HOMEPAGE="http://rudd-o.com/wp-content/projects/files/ups-monitor"
SRC_URI="http://rudd-o.com/wp-content/projects/files/ups-monitor/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-util/desktop-file-utils"
RDEPEND=">=dev-python/gnome-python-2
	>=gnome-base/libglade-2
	>=dev-python/pygtk-2.4
	>=dev-python/pyorbit-2.0.1"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e \
	's/Categories=X-Red-Hat-Base;Application;System;/Categories=System;/g' \
	ups-monitor.desktop || die "Sed Broke!"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README TODO ChangeLog
}
