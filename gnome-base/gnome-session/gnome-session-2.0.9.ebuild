# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-session/gnome-session-2.0.9.ebuild,v 1.5 2002/12/15 10:44:19 bjb Exp $

inherit gnome2 eutils

S=${WORKDIR}/${P}
DESCRIPTION="the Gnome2 session manager"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha"
LICENSE="GPL-2 LGPL-2.1 FDL-1.1"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2
	>=media-sound/esound-0.2.26
	>=gnome-base/libgnomeui-2
	>=gnome-base/libgnomecanvas-2.0.4
	>=sys-devel/gettext-0.10.40
	>=sys-apps/tcp-wrappers-7.6
	>=gnome-base/gconf-1.2.1"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.22
	!gnome-base/gnome-core"

# gnome-base/gnome-core overwrite /usr/bin/gnome-session

DOC="AUTHORS COPY* README HACKING INSTALL NEWS TODO ChangeLog"

src_unpack() {
	unpack ${A}

	epatch ${FILESDIR}/${PN}-2.0-defaults.patch
}

src_install() {
	gnome2_src_install
	
	dodir /etc/X11/Sessions
	exeinto /etc/X11/Sessions
	doexe ${FILESDIR}/Gnome
}




