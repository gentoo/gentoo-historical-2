# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Script Revised by Parag Mehta <pm@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/vlnx/vlnx-416e.ebuild,v 1.2 2002/11/07 19:37:40 gerk Exp $

DAT_VER=4228

MY_P="${P/-/}"
S="${WORKDIR}"
DESCRIPTION="McAfee VirusScanner for Unix/Linux(Shareware)"
SRC_URI="http://download.nai.com/products/evaluation/virusscan/english/cmdline/linux/version_4.16/${MY_P}.tar.Z
	 http://download.nai.com/products/datfiles/4.x/nai/dat-${DAT_VER}.tar"
HOMEPAGE="http://www.mcafee.com/"

SLOT="0"
LICENSE="VirusScan"
KEYWORDS="x86 ~sparc ~sparc64"
RESTRICT="nostrip"
DEPEND=""
RDEPEND=""

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
