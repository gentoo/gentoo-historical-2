# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/glade-sharp/glade-sharp-1.0.4.ebuild,v 1.3 2004/12/04 12:31:57 dholm Exp $

inherit gtk-sharp-component eutils

SLOT="1"
KEYWORDS="~x86"
IUSE=""

DEPEND="${DEPEND}
		>=dev-dotnet/gtk-sharp-1.0.4-r1
		>=gnome-base/libglade-2"
