# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gnome-sharp/gnome-sharp-2.24.1.ebuild,v 1.2 2009/03/27 15:55:16 ranger Exp $

EAPI=2

GTK_SHARP_REQUIRED_VERSION="2.12"
GNOMECANVAS_REQUIRED_VERSION="2.20"
inherit gtk-sharp-module

SLOT="2"
KEYWORDS="~amd64 ppc ~x86 ~x86-fbsd"
IUSE=""

RESTRICT="test"
