# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/b43-fwcutter/b43-fwcutter-008.ebuild,v 1.5 2008/03/22 15:57:36 josejx Exp $

inherit toolchain-funcs

DESCRIPTION="Firmware Tool for Broadcom 43xx based wireless network devices
using the mac80211 wireless stack"
HOMEPAGE="http://bcm43xx.berlios.de"
SRC_URI="http://download.berlios.de/bcm43xx/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 ~x86"

IUSE=""
DEPEND=""
RDEPEND=""

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	# Install fwcutter
	exeinto /usr/bin
	doexe ${PN}
	doman ${PN}.1
	dodoc README
}

pkg_postinst() {
	einfo
	einfo "You'll need to use b43-fwcutter to install the b43 firmware."
	einfo "Please read the b43-fwcutter readme for more details:"
	einfo "README in /usr/share/doc/${P}/"
	einfo

	einfo "Please read this forum thread for help and troubleshooting:"
	einfo "http://forums.gentoo.org/viewtopic-t-409194.html"
	einfo
}
