# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gnome-sharp/gnome-sharp-2.8.2.ebuild,v 1.4 2007/01/18 12:11:36 opfer Exp $

inherit gtk-sharp-component

SLOT="2"
KEYWORDS="amd64 ppc x86"
IUSE=""

# FIXME
DEPEND="${DEPEND}
		>=gnome-base/libgnomecanvas-2.10
		>=gnome-base/libgnomeui-2.10
		>=gnome-base/libgnomeprintui-2.10
		>=gnome-base/gnome-panel-2.10
		>=x11-libs/gtk+-2.6.0
		~dev-dotnet/gnomevfs-sharp-${PV}
		~dev-dotnet/art-sharp-${PV}"

GTK_SHARP_COMPONENT_SLOT="2"
GTK_SHARP_COMPONENT_SLOT_DEC="-2.0"
GTK_SHARP_COMPONENT_BUILD_DEPS="art"
