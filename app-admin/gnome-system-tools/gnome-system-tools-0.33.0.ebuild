# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gnome-system-tools/gnome-system-tools-0.33.0.ebuild,v 1.1 2004/05/26 07:45:53 leonardop Exp $

inherit gnome2

IUSE=""
DESCRIPTION="Tools aimed to make easy the administration of UNIX systems"
HOMEPAGE="http://www.gnome.org/projects/gst/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="net-misc/openssh
	sys-apps/shadow
	sys-libs/cracklib
	>=gnome-base/libgnomeui-1.109
	>=gnome-base/libglade-1.99.5
	>=gnome-base/gconf-2.2
	>=dev-libs/libxml2-2.4.12"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.29"

DOCS="AUTHORS BUGS ChangeLog COPYING HACKING NEWS README TODO"

USE_DESTDIR="1"
