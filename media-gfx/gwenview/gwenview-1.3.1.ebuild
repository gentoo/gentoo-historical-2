# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gwenview/gwenview-1.3.1.ebuild,v 1.1 2005/11/29 21:10:47 hanno Exp $

inherit kde

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="image viewer for KDE"
HOMEPAGE="http://gwenview.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="kipi"

DEPEND="kipi? ( >=media-plugins/kipi-plugins-0.1.0_beta2 )"

need-kde 3

pkg_setup(){
	if use kipi ; then
		slot_rebuild "media-plugins/kipi-plugins" && die
	fi
}

src_compile() {
	local myconf="$(use_enable kipi)"
	kde_src_compile myconf configure
	make || die
}
