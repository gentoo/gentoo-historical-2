# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-desktop/gnome-desktop-2.4.0.ebuild,v 1.5 2003/10/18 22:54:00 brad_mssw Exp $

inherit gnome2 eutils

DESCRIPTION="Libraries for the gnome desktop that is not part of the UI"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
KEYWORDS="x86 ~ppc alpha ~sparc ~hppa amd64"
LICENSE="GPL-2 FDL-1.1 LGPL-2"

RDEPEND=">=x11-libs/gtk+-2.1.2
	>=gnome-base/libgnomeui-2.1
	>=gnome-base/libgnomecanvas-2
	>=gnome-base/gnome-vfs-2
	>=x11-libs/startup-notification-0.5
	>=gnome-base/libbonoboui-2.3
	>=gnome-base/libbonobo-2
	!gnome-base/gnome-core"

# ugh, we don't need libbonobo really, but people bug about it. 
# remove in 2.4.1 release.
DEPEND="${RDEPEND}
	>=sys-devel/automake-1.7.2
	>=dev-util/intltool-0.22
	>=dev-util/pkgconfig-0.12.0
	>=sys-apps/sed-4"

DOCS="AUTHORS ChangeLog COPYING* README INSTALL NEWS HACKING"

src_unpack() {
	unpack ${A}

	# Set vendor info
	cd ${S}
	sed -i 's:GNOME.Org:Gentoo Linux:' configure.in

	WANT_AUTOCONF_2_5=1 autoconf || die
	WANT_AUTOMAKE=1.4 automake || die

	# Fix bug 16853 by building gnome-about with IEEE to prevent
	# floating point exceptions on alpha
	use alpha || return
	cd ${S}/gnome-about
	sed -i '/^CFLAGS/s/$/ -mieee/' Makefile.in

}
