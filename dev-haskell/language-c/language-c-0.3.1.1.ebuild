# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/language-c/language-c-0.3.1.1.ebuild,v 1.3 2010/03/28 09:53:20 kolmodin Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="Analysis and generation of C code"
HOMEPAGE="http://www.sivity.net/projects/language.c/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.6.1
		dev-haskell/filepath"
DEPEND="${RDEPEND}
		dev-haskell/happy
		dev-haskell/alex
		>=dev-haskell/cabal-1.2.3"
