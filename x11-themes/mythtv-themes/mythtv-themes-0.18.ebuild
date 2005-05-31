# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/mythtv-themes/mythtv-themes-0.18.ebuild,v 1.2 2005/05/31 15:19:44 dholm Exp $

DESCRIPTION="A collection of themes for the MythTV project."
HOMEPAGE="http://www.mythtv.org/"
SRC_URI="http://www.mythtv.org/mc/myththemes-${PV}.tar.bz2
	http://www.mythtv.org/myththemes/purgalaxy/PurpleGalaxy.tar.gz
	http://www.mythtv.org/myththemes/visor/visor.tar.gz
	http://www.mythtv.org/myththemes/sleek/sleek-0.35.tar.bz2
	http://www.mythtv.org/myththemes/abstract/abstract.tar.bz2
	http://files.radixpub.com/MythTVMediaCenter.tar.bz2
	http://files.radixpub.com/MythTVMediaCenterOSD.tar.bz2
	http://www.aldorf.no/mythtv/isthmus.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="|| ( >=media-tv/mythtv-${PV} >=media-tv/mythfrontend-${PV} )"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	mv ${S}/myththemes-${PV}/*/ ${S}
	rm -rf ${S}/myththemes-${PV}
}

src_install() {
	find "${S}" -type f -print0 | xargs -0 chmod 644
	find "${S}" -type d -print0 | xargs -0 chmod 755

	dodir /usr/share/mythtv
	cp -r "${S}" "${D}/usr/share/mythtv/themes"
}
