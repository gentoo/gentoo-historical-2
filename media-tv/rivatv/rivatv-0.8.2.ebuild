# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/rivatv/rivatv-0.8.2.ebuild,v 1.6 2004/08/25 02:40:43 swegener Exp $

S=${WORKDIR}/${P/_/-}
DESCRIPTION="kernel driver for nVidia based cards with video-in"
SRC_URI="mirror://sourceforge/rivatv/${P/_/-}.tar.gz"
HOMEPAGE="http://rivatv.sourceforge.net/"
DEPEND="virtual/x11
	>=virtual/linux-sources-2.4.17"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE=""

src_compile() {
	#cd rivatv/linux/drivers/media/video
	econf || die
	emake || die
}

src_install () {
	modp=`awk '/^MODULES/{ print "'${D}'"  $3}' Makefile` || die
	mkdir -p ${modp} || die
	emake MODULES=${modp} DEPMOD=":" install || die
	dodoc README
}

pkg_postinst() {
	depmod -a
	einfo "To load the module automatically at boot up, add these and"
	einfo "\"rivatv\" to your /etc/modules.autoload."
	einfo
	einfo "Also, see ${HOMEPAGE} for more information."
}
