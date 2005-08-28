# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/chasen/chasen-2.4.0_pre1-r1.ebuild,v 1.3 2005/08/28 19:36:56 blubb Exp $

inherit perl-module

MY_P="${P/_pre/-preview}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Japanese Morphological Analysis System, ChaSen"
HOMEPAGE="http://chasen.aist-nara.ac.jp/"
SRC_URI="http://chasen.aist-nara.ac.jp/stable/chasen/${MY_P}.tar.gz"

LICENSE="chasen"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~sparc ~ppc ppc64"
IUSE="perl"

DEPEND=">=dev-libs/darts-0.2"
PDEPEND=">=app-dicts/ipadic-2.6.1"

src_unpack() {
	unpack ${A}

	if use perl ; then
		cd ${S}/perl
		sed -i -e '5a"LD" => "g++",' Makefile.PL || die
	fi
	cd ${S}
	epatch ${FILESDIR}/${P}-gcc34.patch
}

src_compile() {
	econf || die
	emake || die
	if use perl ; then
		cd ${S}/perl
		perl-module_src_compile
	fi
}

src_install () {
	einstall || die

	if use perl ; then
		cd ${S}/perl
		perl-module_src_install
	fi

	cd ${S}
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
}
