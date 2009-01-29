# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/rsvg-sharp/rsvg-sharp-2.24.0-r10.ebuild,v 1.1 2009/01/29 22:46:44 loki_val Exp $

EAPI=2

GTK_SHARP_REQUIRED_VERSION="2.12"
RSVG_REQUIRED_VERSION="2.22.2"

inherit gtk-sharp-module

SLOT="2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

RESTRICT="test"
