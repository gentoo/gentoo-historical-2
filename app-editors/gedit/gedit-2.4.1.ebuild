# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-2.4.1.ebuild,v 1.13 2004/05/14 19:52:55 geoman Exp $

inherit eutils gnome2

DESCRIPTION="A text editor for the Gnome2 desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64 mips"
IUSE="spell"

RDEPEND=">=gnome-base/libglade-2
	>=dev-libs/popt-1.5
	=gnome-base/eel-2.4*
	>=gnome-base/gconf-2
	>=gnome-base/libgnomeui-2.4
	>=gnome-base/libbonobo-2.3
	>=gnome-base/libgnomeprintui-2.4
	>=x11-libs/gtksourceview-0.7
	spell? ( virtual/aspell-dict )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.25"

DOCS="AUTHORS BUGS ChangeLog INSTALL NEWS README THANKS TODO"

src_unpack() {
	unpack ${A}
	cd ${S}
	use amd64 && epatch ${FILESDIR}/gedit-2.4.0-64bit-fix.patch

	# Remove *_DISABLE_DEPRECATED macros so it compiles with recent
	# Gtk+/Gnome libraries. See bug #45514.
	for file in $(find . -name Makefile.in)
	do
		sed -i \
			-e 's:-DGTK_DISABLE_DEPRECATED::g' \
			-e 's:-DGNOME_DISABLE_DEPRECATED::g' \
			$file
	done
}
