# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm_icons/fvwm_icons-1.0.ebuild,v 1.11 2005/10/02 19:36:16 agriffis Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Icons for use with FVWM"
SRC_URI="http://www.fvwm.org/generated/icon_download/fvwm_icons.tar.bz2"
HOMEPAGE="http://www.fvwm.org/"
IUSE=""
DEPEND="x11-wm/fvwm"
KEYWORDS="alpha amd64 ia64 ppc ~sparc x86"
SLOT="0"
LICENSE="GPL-2 FVWM"

src_install () {
	dodir /usr/share/icons/fvwm
	insinto /usr/share/icons/fvwm
	doins ${S}/*
}
