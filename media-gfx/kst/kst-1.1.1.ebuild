# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/kst/kst-1.1.1.ebuild,v 1.1 2005/11/10 17:20:23 greg_g Exp $

inherit kde

DESCRIPTION="A plotting and data viewing program for KDE."
HOMEPAGE="http://kst.kde.org/"
SRC_URI="mirror://kde/stable/apps/KDE3.x/scientific/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="sci-libs/gsl"

need-kde 3.1

src_unpack(){
	kde_src_unpack

	epatch "${FILESDIR}/kst-1.1.0-netcdf-fix.patch"
	make -f admin/Makefile.common || die
}

src_compile() {
	local myconf="--disable-netcdf"

	kde_src_compile
}
