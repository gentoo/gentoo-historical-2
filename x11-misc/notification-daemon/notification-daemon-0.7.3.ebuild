# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/notification-daemon/notification-daemon-0.7.3.ebuild,v 1.1 2011/10/19 02:05:31 ssuominen Exp $

EAPI=4
inherit gnome.org

DESCRIPTION="Notification daemon"
HOMEPAGE="http://git.gnome.org/browse/notification-daemon/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/glib-2.28
	x11-libs/gtk+:3
	sys-apps/dbus
	media-libs/libcanberra[gtk3]
	>=x11-libs/libnotify-0.7
	x11-libs/libX11
	!x11-misc/notify-osd"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/intltool-0.40
	sys-devel/gettext"

DOCS=( AUTHORS ChangeLog NEWS )
