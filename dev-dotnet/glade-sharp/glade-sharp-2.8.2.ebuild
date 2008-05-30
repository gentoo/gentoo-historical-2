# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/glade-sharp/glade-sharp-2.8.2.ebuild,v 1.5 2008/05/30 23:10:33 jurek Exp $

inherit gtk-sharp-component

SLOT="2"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="${DEPEND}
		>=gnome-base/libglade-2.3.6
		dev-util/pkgconfig"

GTK_SHARP_COMPONENT_SLOT="2"
GTK_SHARP_COMPONENT_SLOT_DEC="-2.0"
