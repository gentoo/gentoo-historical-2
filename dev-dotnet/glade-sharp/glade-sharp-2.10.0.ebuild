# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/glade-sharp/glade-sharp-2.10.0.ebuild,v 1.2 2007/01/29 11:55:35 opfer Exp $

inherit gtk-sharp-component

SLOT="2"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="${DEPEND} >=gnome-base/libglade-2.3.6"

GTK_SHARP_COMPONENT_SLOT="2"
GTK_SHARP_COMPONENT_SLOT_DEC="-2.0"
