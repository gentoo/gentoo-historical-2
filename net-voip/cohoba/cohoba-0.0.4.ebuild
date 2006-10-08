# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-voip/cohoba/cohoba-0.0.4.ebuild,v 1.2 2006/10/08 19:17:04 genstef Exp $

inherit eutils

DESCRIPTION="Gnome UI for Telepathy"
HOMEPAGE="http://telepathy.freedesktop.org/"
SRC_URI="http://telepathy.freedesktop.org/releases/cohoba/${P}.tar.gz"
EDARCS_REPOSITORY="http://projects.collabora.co.uk/darcs/telepathy/cohoba/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="dev-python/gnome-python-desktop
	>=sys-apps/dbus-0.61
	x11-themes/gnome-icon-theme
	x11-themes/gnome-themes"
RDEPEND="${DEPEND}
	gnome-base/control-center"

pkg_setup() {
	if ! built_with_use sys-apps/dbus python; then
		eerror "you need to build dbus with USE=python"
		die "dbus needs python bindings"
	fi

}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	einfo "To run cohoba use:"
	einfo "$ /usr/lib/cohoba/cohoba-applet -w"
	einfo "For non-gnome, gnome-settings-daemon needs to be running:"
	einfo "$ /usr/libexec/gnome-settings-daemon"
}
