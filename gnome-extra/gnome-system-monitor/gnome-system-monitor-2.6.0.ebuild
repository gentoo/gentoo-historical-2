# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-system-monitor/gnome-system-monitor-2.6.0.ebuild,v 1.7 2004/06/24 22:06:04 agriffis Exp $

inherit gnome2

DESCRIPTION="The Gnome System Monitor"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 ppc ~alpha ~sparc hppa amd64 ~ia64 mips"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.3
	>=gnome-base/libgnomeui-2
	>=gnome-base/libgnome-2
	>=gnome-base/gconf-2
	>=gnome-base/libgtop-2.5.2
	>=x11-libs/libwnck-2.5"

DEPEND=">=dev-util/pkgconfig-0.12.0
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.29
	${RDEPEND}"

DOCS="AUTHORS ChangeLog COPYING HACKING README INSTALL NEWS TODO"
