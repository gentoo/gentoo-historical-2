# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm_icons/fvwm_icons-1.0.ebuild,v 1.9 2004/06/24 23:26:13 agriffis Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Icons for use with FVWM"
SRC_URI="http://www.fvwm.org/generated/icon_download/fvwm_icons.tar.bz2"
HOMEPAGE="http://www.fvwm.org/"
IUSE=""
DEPEND="x11-wm/fvwm"
KEYWORDS="x86 alpha ~sparc ppc amd64"
SLOT="0"
LICENSE="GPL-2 FVWM"

src_install () {
	dodir /usr/share/icons/fvwm
	insinto /usr/share/icons/fvwm
	doins ${S}/*
}
