# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/rsvg-sharp/rsvg-sharp-1.0.4.ebuild,v 1.5 2005/03/15 00:04:19 latexer Exp $

inherit gtk-sharp-component

SLOT="1"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="${DEPEND}
		>=dev-dotnet/gtk-sharp-1.0.4-r1
		=dev-dotnet/art-sharp-${PV}*
		>=gnome-base/librsvg-2.0"

GTK_SHARP_COMPONENT_BUILD_DEPS="art"
