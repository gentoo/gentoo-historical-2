# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-dvdselect/vdr-dvdselect-0.8.ebuild,v 1.1 2007/01/08 20:30:25 hd_brummy Exp $

inherit vdr-plugin eutils

DESCRIPTION="VDR plugin: mount multiple DVD-Images to the dvd-device"
HOMEPAGE="http://www.vdr-wiki.de/wiki/index.php/Dvdselect-plugin"
SRC_URI="mirror://vdrfiles/${PN}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.9
	>=media-tv/vdr-dvd-scripts-0.0.1-r1"

PATCHES="${FILESDIR}/${P}-gentoo.diff"
