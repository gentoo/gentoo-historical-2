# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Script Revised by Parag Mehta <pm@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-antivirus/vlnx/vlnx-416e.ebuild,v 1.3 2004/06/24 21:27:14 agriffis Exp $

DAT_VER=4228

MY_P="${P/-/}"
S="${WORKDIR}"
DESCRIPTION="McAfee VirusScanner for Unix/Linux(Shareware)"
SRC_URI="http://download.nai.com/products/evaluation/virusscan/english/cmdline/linux/version_4.16/${MY_P}.tar.Z
	http://download.nai.com/products/datfiles/4.x/nai/dat-4240.tar"
HOMEPAGE="http://www.mcafeeb2b.com/"

SLOT="0"
LICENSE="VirusScan"
KEYWORDS="-* x86"
IUSE=""
RESTRICT="nostrip"

DEPEND=""
RDEPEND="sys-libs/lib-compat"
PROVIDE="virtual/antivirus"

src_install() {
	insinto /opt/vlnx

	doins liblnxfv.so.4
	dosym /opt/vlnx/liblnxfv.so.4 /opt/vlnx/liblnxfv.so
	doins *.{dat,ini}

	insopts -m755
	doins uvscan

	dodoc *.{diz,lst,pdf,txt}
	doman uvscan.1

	insinto /etc/env.d
	newins ${FILESDIR}/vlnx-${PV}-envd 40vlnx
}
