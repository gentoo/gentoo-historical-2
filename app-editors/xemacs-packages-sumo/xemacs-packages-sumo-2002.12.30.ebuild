# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/xemacs-packages-sumo/xemacs-packages-sumo-2002.12.30.ebuild,v 1.3 2003/02/13 07:02:21 vapier Exp $

DESCRIPTION="The SUMO bundle of ELISP packages for Xemacs"
HOMEPAGE="http://www.xemacs.org"
SRC_URI="http://ftp.xemacs.org/pub/packages/xemacs-sumo-${PV//./-}.tar.bz2
	http://ftp.xemacs.org/pub/Attic/packages/oldsumo/xemacs-sumo-${PV//./-}.tar.bz2
	mule? ( http://ftp.xemacs.org/pub/packages/xemacs-mule-sumo-${PV//./-}.tar.bz2
		http://ftp.xemacs.org/pub/Attic/packages/oldsumo/xemacs-mule-sumo-${PV//./-}.tar.bz2 )"

DEPEND="sys-apps/tar sys-apps/bzip2"
RDEPEND=""
S="${WORKDIR}"

IUSE="mule"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc"

src_compile() {
	true
}

src_install() {
	dodir /usr/lib/xemacs
	local DEST="${D}/usr/lib/xemacs/"
	mv xemacs-packages "${DEST}" || die
	if [ "`use mule`" ]
	then
		mv mule-packages "${DEST}" || die
	fi
}
