# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/regex-compat/regex-compat-0.90.ebuild,v 1.6 2008/03/01 11:28:25 armin76 Exp $

CABAL_FEATURES="profile haddock lib"
inherit haskell-cabal

DESCRIPTION="Replaces/Enhances Text.Regex"
HOMEPAGE="http://sourceforge.net/projects/lazy-regex"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ~ia64 ~sparc ~x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.6
		>=dev-haskell/regex-base-0.80
		>=dev-haskell/regex-posix-0.80"
