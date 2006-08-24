# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-adzap/vdr-adzap-0.0.2.ebuild,v 1.1 2006/08/24 17:18:50 zzam Exp $

inherit vdr-plugin

DESCRIPTION="VDR Plugin: Zap back to the channel when advertisment is over (works best for some german channels)"
HOMEPAGE="http://www.vdr-portal.de/board/thread.php?threadid=31410"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.20"
RDEPEND="${DEPEND}"

PATCHES="${FILESDIR}/${P}-gentoo.diff"

src_install() {
	vdr-plugin_src_install

	insinto /usr/share/vdr/${VDRPLUGIN}
	insopts -m755
	doins examples/*.sh

	keepdir /var/vdr/adzap

	# chown /var/vdr to user vdr
	chown -R vdr:vdr ${D}/var/vdr
}
