# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/glade-sharp/glade-sharp-1.0.4.ebuild,v 1.5 2004/12/30 23:21:25 swegener Exp $

inherit eutils gtk-sharp-component

SLOT="1"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="${DEPEND}
		>=dev-dotnet/gtk-sharp-1.0.4-r1
		>=gnome-base/libglade-2"
