# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/art-sharp/art-sharp-2.4.0.ebuild,v 1.1 2005/11/08 04:04:20 latexer Exp $

inherit gtk-sharp-component

SLOT="2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="${DEPEND} >=media-libs/libart_lgpl-2.3.16"

GTK_SHARP_COMPONENT_SLOT="2"
GTK_SHARP_COMPONENT_SLOT_DEC="-2.0"
