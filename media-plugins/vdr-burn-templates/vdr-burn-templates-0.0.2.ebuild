# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-burn-templates/vdr-burn-templates-0.0.2.ebuild,v 1.2 2006/10/26 08:33:43 zzam Exp $

DESCRIPTION="DVD-themes (background and menu) for vdr-burn"
HOMEPAGE="http://www.vdr-wiki.de/wiki/index.php/Vorlagen_(burn-plugin)"
SRC_URI="mirror://gentoo/${P}.tar.gz"

KEYWORDS="~amd64 x86"
SLOT="0"
LICENSE="as-is"
IUSE=""

RDEPEND=">=media-plugins/vdr-burn-0.0.9-r2"

S="${WORKDIR}/templates"

src_unpack() {

	unpack ${A}
	cd ${S}
}

src_install() {

	insinto /usr/share/vdr/burn
	insopts -m0644 -ovdr -gvdr
	doins ${S}/*
}
