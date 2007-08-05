# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/regex-compat/regex-compat-0.71.ebuild,v 1.1 2007/08/05 19:33:56 kolmodin Exp $

CABAL_FEATURES="profile haddock lib"
inherit haskell-cabal

DESCRIPTION="Replaces/Enhances Text.Regex"
HOMEPAGE="http://sourceforge.net/projects/lazy-regex"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.6
		=dev-haskell/regex-base-0.7*
		=dev-haskell/regex-posix-0.7*"

CABAL_CORE_LIB_GHC_PV="6.6 6.6.1"
