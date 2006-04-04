# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/vdr-dvd-scripts/vdr-dvd-scripts-0.0.1-r4.ebuild,v 1.1 2006/04/04 21:21:38 hd_brummy Exp $

DESCRIPTION="scripts for vdr-plugins vdrselect and vdrswitch"
HOMEPAGE="http://www.vdr-wiki.de/wiki/index.php/Dvdselect_readdvd.sh"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=media-tv/gentoo-vdr-scripts-0.1"

src_install() {
	exeinto /usr/share/vdr/dvdchanger
	exeopts -m0755
	doexe ${FILESDIR}/${PV}/*.sh
}
