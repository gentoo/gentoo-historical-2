# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgtkhtml/libgtkhtml-2.4.0.ebuild,v 1.4 2003/10/18 22:54:00 brad_mssw Exp $

inherit eutils gnome2

S=${WORKDIR}/${P}
DESCRIPTION="a Gtk+ based HTML rendering library"
HOMEPAGE="http://www.gnome.org/"
SLOT="1"
LICENSE="LGPL-2.1 GPL-2"
KEYWORDS="x86 ~ppc ~alpha ~sparc amd64"

# FIXME : seems only testapps need gnomevfs
RDEPEND=">=x11-libs/gtk+-2
	>=dev-libs/libxml2-2.4.16
	>=gnome-base/gnome-vfs-2
	>=gnome-base/gail-1.3"

DEPEND="${RDEPEND}
	 >=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS COPYING* ChangeLog INSTALL NEWS  README TODO docs/IDEAS"

MAKEOPTS="${MAKEOPTS} -j1"

src_unpack() {
	unpack ${A}
	cd ${S}
	if use alpha; then
		epatch ${FILESDIR}/${PN}-2.2.0-alpha.patch || die
	fi
}
