# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gnome-system-tools/gnome-system-tools-2.22.1.ebuild,v 1.1 2008/09/27 17:12:33 eva Exp $

inherit gnome2

DESCRIPTION="Tools aimed to make easy the administration of UNIX systems"
HOMEPAGE="http://www.gnome.org/projects/gst/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nfs samba"

# TODO: policykit seems to be an option but has no configure switch

RDEPEND="
	>=dev-libs/liboobs-2.21.3
	>=x11-libs/gtk+-2.11.3
	>=dev-libs/glib-2.15.2
	>=gnome-base/gconf-2.2
	dev-libs/dbus-glib
	>=gnome-base/nautilus-2.9.90
	sys-libs/cracklib
	nfs? ( net-fs/nfs-utils )
	samba? ( >=net-fs/samba-3 )"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	dev-util/pkgconfig
	>=dev-util/intltool-0.35.0"

DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"

pkg_setup() {
	if ! use nfs && ! use samba; then
		G2CONF="${G2CONF} --disable-shares"
	fi
}
