# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/qalculate-kde/qalculate-kde-0.9.6-r1.ebuild,v 1.7 2008/10/12 16:02:18 nixnut Exp $

inherit kde

DESCRIPTION="A modern multi-purpose calculator for KDE"
LICENSE="GPL-2"
HOMEPAGE="http://qalculate.sourceforge.net/"
SRC_URI="mirror://sourceforge/qalculate/${P}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="amd64 ppc ~sparc x86"

DEPEND=">=sci-libs/libqalculate-0.9.6-r1"

need-kde 3.1

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_unpack() {
	kde_src_unpack
	epatch "${FILESDIR}"/${P}-remove-link.patch
	epatch "${FILESDIR}"/${P}-cln-config.patch
}

src_compile() {
	# remove configure to force rebuild of autotools
	# by the kde eclass
	rm -f ./configure || die "Failed to remove configure"

	kde_src_compile myconf configure

	# get rid of the -fno-exceptions flag since it breaks cln
	sed -e "s:\$CXXFLAGS -fno-exceptions:\$CXXFLAGS:" \
		-i configure \
		|| die "Failed to remove -fno-exceptions from configure script"

	kde_src_compile make
}
