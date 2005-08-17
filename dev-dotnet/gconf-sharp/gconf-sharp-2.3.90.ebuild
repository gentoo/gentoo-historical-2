# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gconf-sharp/gconf-sharp-2.3.90.ebuild,v 1.1 2005/08/17 00:38:30 latexer Exp $

inherit gtk-sharp-component

SLOT="2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="${DEPEND}
		>=gnome-base/gconf-2.0
		=dev-dotnet/glade-sharp-${PV}*
		=dev-dotnet/gnome-sharp-${PV}*
		=dev-dotnet/art-sharp-${PV}*"

GTK_SHARP_COMPONENT_BUILD="gnome"
GTK_SHARP_COMPONENT_BUILD_DEPS="art"
GTK_SHARP_COMPONENT_SLOT="2"
GTK_SHARP_COMPONENT_SLOT_DEC="-2.0"


src_unpack() {
	gtk-sharp-component_src_unpack

	# Fix need as GConf.PropertyEditors references a locally built dll
	sed -i "s:${GTK_SHARP_LIB_DIR}/gconf-sharp.dll:../GConf/gconf-sharp.dll:" \
		${S}/gconf/GConf.PropertyEditors/Makefile.in
}
