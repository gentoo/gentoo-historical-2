# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/gnome-terminal/gnome-terminal-2.6.1.ebuild,v 1.10 2004/10/01 06:57:19 geoman Exp $

inherit gnome2 eutils

DESCRIPTION="The Gnome Terminal"
IUSE=""
HOMEPAGE="http://www.gnome.org/"
KEYWORDS="x86 ~ppc alpha sparc hppa amd64 ~ia64 mips"
SLOT="0"
LICENSE="GPL-2"

RDEPEND="virtual/xft
	>=x11-libs/gtk+-2.2
	>=gnome-base/libglade-2
	>=gnome-base/gconf-1.2
	>=gnome-base/libgnomeui-2
	>=gnome-base/gnome-vfs-2.4
	>=x11-libs/startup-notification-0.4
	>=x11-libs/vte-0.11"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.29
	!gnome-base/gnome-core"
# gnome-core overwrite /usr/bin/gnome-terminal

src_unpack() {

	unpack ${A}

	cd ${S}
	# Use login shell by default (#12900) 
	epatch ${FILESDIR}/${PN}-2-default_shell.patch
	# terminal enhancement, inserts a space after a DND URL
	# patch by Zach Bagnall <yem@y3m.net> in #13801
	epatch ${FILESDIR}/${PN}-2-dnd_url_add_space.patch

	# gcc 3.4 fix
	epatch ${FILESDIR}/${P}-gcc34_eggcell.patch

}

DOCS="AUTHORS ChangeLog COPYING README INSTALL NEWS TODO"
