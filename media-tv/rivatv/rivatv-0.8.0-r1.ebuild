# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/rivatv/rivatv-0.8.0-r1.ebuild,v 1.5 2004/08/25 02:40:43 swegener Exp $

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
	emake KERNEL="/usr/src/linux" || die
}

src_install () {
	insinto /lib/modules/${KV}/kernel/drivers/media/video
	doins *.o

	dodoc README
}

pkg_postinst() {
	depmod -a
	einfo "You will need support for videodev, i2c-core, i2c-algo-bit"
	einfo "for this driver to work, plus your cards' specific modules"
	einfo "from /lib/modules/${KV}/kernel/drivers/media/video"
	einfo
	einfo "To load the module automatically at boot up, add these and"
	einfo "\"rivatv\" to your /etc/modules.autoload."
	einfo
	einfo "Also, see ${HOMEPAGE} for more information."
	einfo
	einfo "NOTE: Your kernel must not include framebuffer support."
}
