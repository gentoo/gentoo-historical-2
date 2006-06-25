# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/oooqs/oooqs-2.1.0.ebuild,v 1.6 2006/06/25 16:53:57 blubb Exp $

inherit kde eutils

need-kde 3

MY_P="${PN}2-1.0"
DESCRIPTION="OpenOffice.org Quickstarter, runs in the KDE SystemTray"
HOMEPAGE="http://segfaultskde.berlios.de/index.php"
SRC_URI="http://download.berlios.de/segfaultskde/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""
SLOT="0"

RDEPEND=">=virtual/ooo-2.0.0
	|| ( kde-base/ksysguard kde-base/kdebase )"

src_unpack() {
	unpack ${A}
	cd ${S}
	# OO.o on Gentoo (either binary or source package) use slightly
	# different icon names
	epatch ${FILESDIR}/icon_names.diff
	# oooqs2 is looking for a wrapper script that has other name on gentoo
	epatch ${FILESDIR}/oooqs2.patch
}
