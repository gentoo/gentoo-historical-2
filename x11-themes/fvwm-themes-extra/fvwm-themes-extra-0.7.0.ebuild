# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm-themes-extra/fvwm-themes-extra-0.7.0.ebuild,v 1.5 2004/06/24 23:26:44 agriffis Exp $

IUSE=""

inherit eutils

DESCRIPTION="Extra themes for fvwm-themes"
HOMEPAGE="http://fvwm-themes.sourceforge.net/"
SRC_URI="mirror://sourceforge/fvwm-themes/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="x86 ~amd64 ppc"
SLOT="0"

DEPEND="x11-themes/fvwm-themes"


src_install () {
	mkdir -p ${D}/usr/share/fvwm/themes/
	cp -r ${S}/* ${D}/usr/share/fvwm/themes/
}

