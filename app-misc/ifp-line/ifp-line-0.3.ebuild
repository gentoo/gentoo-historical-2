# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ifp-line/ifp-line-0.3.ebuild,v 1.1 2006/02/01 15:13:47 chutzpah Exp $

inherit eutils

DESCRIPTION="iRiver iFP open-source driver"
HOMEPAGE="http://ifp-driver.sourceforge.net/"
SRC_URI="mirror://sourceforge/ifp-driver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-libs/libusb"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-fix-warnings.patch
}

src_install() {
	dobin ifp || die
	dodoc NEWS README TIPS ChangeLog
	doman ifp.1

	exeinto /usr/share/${PN}
	doexe nonroot.sh
}

pkg_postinst() {
	einfo
	einfo "To enable non-root usage of ${PN}, you use any of the following"
	einfo "methods."
	einfo
	einfo " 1. Merge media-sound/libifp-module and add the module to"
	einfo "    /etc/modules.autoload.d/kernel-2.X (X being 4 or 6 depending"
	einfo "    on what kernel you use."
	einfo
	einfo " 2. Follow the instructions in"
	einfo "      /usr/share/doc/${PF}/TIPS.gz"
	einfo
	einfo " 3. Run /usr/share/${PN}/nonroot.sh"
	einfo
}
