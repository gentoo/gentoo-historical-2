# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-voip/cohoba/cohoba-0.0.4.ebuild,v 1.4 2006/11/20 18:06:50 peper Exp $

inherit eutils

DESCRIPTION="Gnome UI for Telepathy"
HOMEPAGE="http://telepathy.freedesktop.org/"
SRC_URI="http://telepathy.freedesktop.org/releases/cohoba/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/gnome-python-desktop
	dev-python/telepathy-python
	x11-themes/gnome-icon-theme
	x11-themes/gnome-themes"

RDEPEND="${DEPEND}
	gnome-base/control-center"

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	elog "To run cohoba use:"
	elog "$ /usr/lib/cohoba/cohoba-applet -w"
	elog "For non-gnome, gnome-settings-daemon needs to be running:"
	elog "$ /usr/libexec/gnome-settings-daemon"
}
