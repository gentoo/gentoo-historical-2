# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/gaffitter/gaffitter-0.6.0.ebuild,v 1.1 2010/06/04 21:16:49 hwoarang Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="Genetic Algorithm File Fitter"
HOMEPAGE="http://gaffitter.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	sed -i  -e "/^INCLUDES\ =.*/d" \
		-e "s/^CXXFLAGS\ =.*/CXXFLAGS\ =\ ${CXXFLAGS}/" \
		-e "s/^CXX\ =.*/CXX\ =\ $(tc-getCXX)/" src/Makefile || die "sed failed"
}

src_install() {
	dobin src/gaffitter || die "dobin failed"
	dodoc AUTHORS README || die "dodoc failed"
}
