# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/xemacs-packages-sumo/xemacs-packages-sumo-2003.11.13.ebuild,v 1.4 2005/01/01 17:21:23 eradicator Exp $

DESCRIPTION="The SUMO bundle of ELISP packages for Xemacs"
HOMEPAGE="http://www.xemacs.org"
SRC_URI="http://ftp.xemacs.org/pub/packages/xemacs-sumo-${PV//./-}.tar.bz2
	http://ftp.xemacs.org/pub/Attic/packages/oldsumo/xemacs-sumo-${PV//./-}.tar.bz2
	mule? ( http://ftp.xemacs.org/pub/packages/xemacs-mule-sumo-${PV//./-}.tar.bz2
		http://ftp.xemacs.org/pub/Attic/packages/oldsumo/xemacs-mule-sumo-${PV//./-}.tar.bz2 )"

DEPEND="app-arch/tar app-arch/bzip2 virtual/xemacs"
RDEPEND=""
S="${WORKDIR}"

IUSE="mule"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc alpha ~ppc"

src_compile() {
	true
}

src_install() {
	dodir /usr/lib/xemacs
	local DEST="${D}/usr/lib/xemacs/"
	mv xemacs-packages "${DEST}" || die
	if use mule
	then
		mv mule-packages "${DEST}" || die
	fi
}
