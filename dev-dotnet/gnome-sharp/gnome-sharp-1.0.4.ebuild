# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gnome-sharp/gnome-sharp-1.0.4.ebuild,v 1.10 2005/03/14 23:56:06 latexer Exp $

inherit gtk-sharp-component

SLOT="1"
KEYWORDS="x86 ~ppc"
IUSE=""

# FIXME
DEPEND="${DEPEND}
		>=dev-dotnet/gtk-sharp-1.0.4-r1
		>=gnome-base/libgnomecanvas-2.0
		>=gnome-base/libgnomeui-2.0
		>=gnome-base/libgnomeprintui-2.0
		>=x11-libs/gtk+-2.0
		=dev-dotnet/art-sharp-${PV}*"

GTK_SHARP_COMPONENT_BUILD_DEPS="art"
