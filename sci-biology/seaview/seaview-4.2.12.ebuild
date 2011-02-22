# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/seaview/seaview-4.2.12.ebuild,v 1.3 2011/02/22 16:53:39 scarabeus Exp $

EAPI="2"

inherit toolchain-funcs multilib eutils base

DESCRIPTION="A graphical multiple sequence alignment editor"
HOMEPAGE="http://pbil.univ-lyon1.fr/software/seaview.html"
SRC_URI="ftp://pbil.univ-lyon1.fr/pub/mol_phylogeny/seaview/archive/${PN}_${PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+xft"

DEPEND="x11-libs/fltk:1.1
	xft? (	x11-libs/libXft
			x11-libs/fltk:1.1[xft] )"
RDEPEND="${DEPEND}
	sci-biology/clustalw
	|| ( sci-libs/libmuscle sci-biology/muscle )
	sci-biology/phyml"

S="${WORKDIR}/${PN}"

src_prepare() {
	# respect CXXFLAGS (package uses them as CFLAGS)
	sed -i \
		-e "s:^CXX.*:CXX = $(tc-getCXX):" \
		-e "s:\$(OPT):${CXXFLAGS}:" \
		-e "s:^OPT:#OPT:" \
		-e "s:^#IFLTK .*:IFLTK = $(fltk-config --use-images --cxxflags):" \
		-e "s:^#LFLTK .*:LFLTK = $(fltk-config --use-images --ldflags):" \
		-e "s:^USE_XFT:#USE_XFT:" \
		-e "s:^#HELPFILE:HELPFILE:" \
		-e "s:^#PHYMLNAME:PHYMLNAME:" \
		Makefile || die "sed failed while editing Makefile"

	if use xft; then
		sed -i \
			-e "s:^#USE_XFT .*:USE_XFT = -DUSE_XFT $(pkg-config --cflags xft):" \
			-e "s:-lXft:$(pkg-config --libs xft):" \
			Makefile || die "sed failed while editing Makefile to enable xft"
	else
		sed -i -e "s:-lXft::" Makefile || die
	fi
	base_src_prepare
}

src_install() {
	dobin seaview || die

	# /usr/share/seaview/seaview.html is hardcoded in the binary, see Makefile
	insinto /usr/share/seaview
	doins example.nxs seaview.html

	insinto /usr/share/seaview/images
	doins seaview.xpm || die

	make_desktop_entry seaview Seaview

	doman seaview.1 || die
}
