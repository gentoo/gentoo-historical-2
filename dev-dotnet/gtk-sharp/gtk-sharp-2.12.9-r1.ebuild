# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gtk-sharp/gtk-sharp-2.12.9-r1.ebuild,v 1.1 2009/10/18 13:52:56 flameeyes Exp $

EAPI="2"

inherit gtk-sharp-module eutils

SLOT="2"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cellrenderer.patch
	gtk-sharp-module_src_prepare
}
