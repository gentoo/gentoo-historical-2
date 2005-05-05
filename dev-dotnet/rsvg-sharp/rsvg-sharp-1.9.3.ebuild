# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/rsvg-sharp/rsvg-sharp-1.9.3.ebuild,v 1.1 2005/05/05 02:17:31 latexer Exp $

inherit gtk-sharp-component

SLOT="2"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="${DEPEND}
		=dev-dotnet/art-sharp-${PV}*
		>=gnome-base/librsvg-2.0"

GTK_SHARP_COMPONENT_SLOT="2"
GTK_SHARP_COMPONENT_SLOT_DEC="-2.0"
GTK_SHARP_COMPONENT_BUILD_DEPS="art"
