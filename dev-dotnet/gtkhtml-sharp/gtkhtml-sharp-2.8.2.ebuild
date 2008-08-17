# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gtkhtml-sharp/gtkhtml-sharp-2.8.2.ebuild,v 1.7 2008/08/17 04:26:29 mr_bones_ Exp $

inherit gtk-sharp-component

SLOT="2"
KEYWORDS="amd64 ppc ~x86"
IUSE=""

DEPEND="${DEPEND}
		=dev-dotnet/gnome-sharp-${PV}*
		=dev-dotnet/art-sharp-${PV}*
		dev-util/pkgconfig
		|| (
			=gnome-extra/gtkhtml-3.6*
			=gnome-extra/gtkhtml-3.2*
		)"

GTK_SHARP_COMPONENT_SLOT="2"
GTK_SHARP_COMPONENT_SLOT_DEC="-2.0"
GTK_SHARP_COMPONENT_BUILD_DEPS="art gnome"
