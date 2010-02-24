# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm-themes-extra/fvwm-themes-extra-0.7.0.ebuild,v 1.13 2010/02/24 14:27:06 ssuominen Exp $

inherit eutils

DESCRIPTION="Extra themes for fvwm-themes"
HOMEPAGE="http://fvwm-themes.sourceforge.net/"
SRC_URI="mirror://sourceforge/fvwm-themes/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="x11-themes/fvwm-themes"

src_install() {
	mkdir -p "${D}"/usr/share/fvwm/themes/
	cp -r "${S}"/* "${D}"/usr/share/fvwm/themes/
}
