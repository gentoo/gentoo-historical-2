# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kadslwatch/kadslwatch-01.00.05.ebuild,v 1.4 2004/12/05 17:05:16 motaboy Exp $

inherit kde eutils

DESCRIPTION="K ADSL Watch is a universal CAPI based ADSL monitor for KDE."
HOMEPAGE="http://www.avm.de/de/Service/AVM_Service_Portale/Linux/CAPI_Tools/K_ADSL_Watch.html"
SRC_URI="ftp://ftp.avm.de/tools/k_adsl_watch.linux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE=""
DEPEND="net-dialup/capi4k-utils"

need-kde 3

src_unpack() {
	kde_src_unpack

	epatch ${FILESDIR}/${P}-Makefiles.patch
	use arts || epatch ${FILESDIR}/${P}-configure.patch
}

src_install() {
	kde_src_install make
	dohtml *.htm*
	dodoc *.lsm
}
