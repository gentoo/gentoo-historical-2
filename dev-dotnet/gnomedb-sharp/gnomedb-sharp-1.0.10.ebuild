# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gnomedb-sharp/gnomedb-sharp-1.0.10.ebuild,v 1.5 2007/08/04 14:02:15 jurek Exp $

inherit gtk-sharp-component

SLOT="1"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="${DEPEND}
		=dev-dotnet/gtk-sharp-${PV}*
		=dev-dotnet/art-sharp-${PV}*
		=dev-dotnet/gda-sharp-${PV}*
		=dev-dotnet/gnome-sharp-${PV}*
		=gnome-extra/libgnomedb-1*"

GTK_SHARP_COMPONENT_BUILD_DEPS="art gda gnome"
