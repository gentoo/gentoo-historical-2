# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/umodpack/umodpack-0.5_beta16.ebuild,v 1.6 2004/09/27 09:48:58 eradicator Exp $

inherit perl-module

MY_P="${P/_beta/b}"
DESCRIPTION="portable and useful [un]packer for Unreal Tournament's Umod files"
HOMEPAGE="http://umodpack.sourceforge.net/"
SRC_URI="mirror://sourceforge/umodpack/${MY_P}-nogui.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 ppc ~amd64"
IUSE="X tcltk"

DEPEND="dev-lang/perl
	dev-perl/Archive-Zip
	dev-perl/Tie-IxHash
	tcltk? ( dev-perl/perl-tk )
	X? ( virtual/x11 )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	# remove the stupid perl modules since we already installed em
	rm -rf {Archive-Zip,Compress-Zlib,Tie-IxHash}*
	perl-module_src_compile
}

src_install() {
	perl-module_src_install
	dobin umod
	use X && dobin xumod
}
