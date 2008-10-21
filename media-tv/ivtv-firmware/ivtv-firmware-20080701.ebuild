# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/ivtv-firmware/ivtv-firmware-20080701.ebuild,v 1.2 2008/10/21 18:21:44 cardoe Exp $

DESCRIPTION="firmware for Hauppauge PVR-x50 and Conexant 2341x based cards"
HOMEPAGE="http://www.ivtvdriver.org/index.php/Firmware"
SRC_URI="http://dl.ivtvdriver.org/ivtv/firmware/${P}.tar.gz"

RESTRICT="mirror"
SLOT="0"
LICENSE="Hauppauge-Firmware"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
RDEPEND=""

S="${WORKDIR}"

src_install() {
	dodir /lib/firmware
	insinto /lib/firmware
	doins *.fw
	doins *.mpg
}
