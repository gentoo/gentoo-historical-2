# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gcalctool/gcalctool-4.4.16.ebuild,v 1.3 2004/09/22 18:15:33 gustavoz Exp $

inherit gnome2

DESCRIPTION="A scientific calculator for Gnome2"
HOMEPAGE="http://calctool.sourceforge.net/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 ~ppc sparc ~hppa ~alpha ~ia64 ~amd64 ~mips"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/gconf-1.2"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO MAINTAINERS"

src_install() {

	gnome2_src_install

	# remove symlink that conflicts with <2.3 gnome-utils
	rm -f ${D}/usr/bin/gnome-calculator

}
