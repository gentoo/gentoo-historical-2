# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gcalctool/gcalctool-4.3.3.ebuild,v 1.1 2003/09/10 14:26:43 foser Exp $

inherit gnome2

DESCRIPTION="A scientific calculator for Gnome2"
HOMEPAGE="http://calctool.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/gconf-1.2"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	dev-util/pkgconfig"

DOCS="AUTHORS COPYING ChangeLog NEWS README TODO MAINTAINERS"

src_install() {
	gnome2_src_install

	# remove symlink that conflicts with <2.3 gnome-utils
	rm -f ${D}/usr/bin/gnome-calculator
}
