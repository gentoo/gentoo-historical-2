# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/nut/nut-16.5.ebuild,v 1.6 2011/05/23 00:38:56 jer Exp $

EAPI=2

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Record what you eat and analyze your nutrient levels"
HOMEPAGE="http://nut.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~x86"
IUSE="X"

RDEPEND="X? ( x11-libs/fltk:1 )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build-fixes.patch \
		"${FILESDIR}"/${P}-int.patch
	tc-export CC CXX
	sed \
		-e "s:/usr/local/lib:/usr/share:g" \
		-i Makefile fltk/Makefile || die
}

src_compile() {
	emake || die
# need fltk-1.3
	if use X; then
		cd fltk
		emake || die
	fi
}

src_install() {
	insinto /usr/share/nut
	doins raw.data/* || die
	dobin nut || die
	if use X; then
		dobin fltk/Nut || die
	fi
	doman nut.1 || die

}
