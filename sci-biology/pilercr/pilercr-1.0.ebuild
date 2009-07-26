# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/pilercr/pilercr-1.0.ebuild,v 1.2 2009/07/26 17:44:35 weaver Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Analysis of Clustered Repetitive Interspersed Short Palindromic Repeats (CRISPRs)"
HOMEPAGE="http://www.drive5.com/pilercr/"
#SRC_URI="http://www.drive5.com/pilercr/pilercr.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch || die
}

src_compile() {
	emake GPP="$(tc-getCXX)" CFLAGS="${CXXFLAGS}" || die
}

src_install() {
	dobin pilercr || die
}
