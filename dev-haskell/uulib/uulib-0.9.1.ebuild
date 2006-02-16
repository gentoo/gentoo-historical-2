# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/uulib/uulib-0.9.1.ebuild,v 1.3 2006/02/16 13:29:16 dcoutts Exp $

CABAL_FEATURES="haddock cpphs lib"
inherit base haskell-cabal

DESCRIPTION="The Utrecht University parsing, printing and DData libraries"
HOMEPAGE="http://www.cs.uu.nl/wiki/HUT/AttributeGrammarSystem"
SRC_URI="http://abaris.zoo.cs.uu.nl:8080/wiki/pub/HUT/Download/${P}-src.tar.gz"
LICENSE="LGPL-2.1-UUST"
SLOT="0"

KEYWORDS="~x86 ~amd64"	#if possible try testing with "~ppc" and "~sparc"
IUSE=""

DEPEND=">=virtual/ghc-6.2.2
		>=dev-haskell/cpphs-0.9"

src_unpack() {
	base_src_unpack

	# fixes for cpp that comes with later versions of gcc.
	# it should really use cpphs instead.
	sed -i 's:infixl 9 \\\\:infixl 9 \\\\ --not a line continuation:' \
		"${S}/src/UU/DData/Set.hs"	\
		"${S}/src/UU/DData/MultiSet.hs" \
		"${S}/src/UU/DData/IntBag.hs"
	sed -i 's:infixl 9 !,\\\\:infixl 9 !,\\\\ --not a line continuation:' \
		"${S}/src/UU/DData/Map.hs"
}
