# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-cd-burner/nautilus-cd-burner-0.6.1.ebuild,v 1.12 2004/05/15 23:55:52 geoman Exp $

inherit gnome2 eutils

DESCRIPTION="CD and DVD writer plugin for Nautilus"
HOMEPAGE="http://www.gnome.org/"
IUSE="dvdr"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc hppa amd64 alpha ia64 mips"
# Should work on alpha and ia64 too, but can't add those because of
# KEYWORDS borkage with dvd+rw-tools. 


RDEPEND=">=dev-libs/glib-2.2
	>=x11-libs/gtk+-2
	>=gnome-base/gnome-vfs-2.2
	>=gnome-base/eel-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2
	app-cdr/cdrtools
	dvdr? ( app-cdr/dvd+rw-tools )"

DEPEND=">=dev-util/intltool-0.22
	>=dev-util/pkgconfig-0.9.0
	${RDEPEND}"

src_unpack() {
# this solves errors with:
# The OrigTree module doesn't seem to be properly installed ./intltool-merge
	unpack ${A}
	cd ${S}
	intltoolize --force

	epatch ${FILESDIR}/${P}-gcc2_fix.patch
}
DOCS="AUTHORS ChangeLog COPYING INSTALL NEWS README TODO"
