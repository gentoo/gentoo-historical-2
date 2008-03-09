# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-skinenigmang/vdr-skinenigmang-0.0.3.ebuild,v 1.2 2008/03/09 18:31:09 zzam Exp $

inherit vdr-plugin

DESCRIPTION="VDR - Skin Plugin: enigma-ng"
HOMEPAGE="http://andreas.vdr-developer.org/enigmang/"
SRC_URI="http://andreas.vdr-developer.org/enigmang/download/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.44"

RDEPEND="${DEPEND}
		x11-themes/skinenigmang-logos"

S=${WORKDIR}/skinenigmang-${PV}

src_install() {
	vdr-plugin_src_install

	insinto /etc/vdr/themes
	doins "${S}"/themes/*
}
