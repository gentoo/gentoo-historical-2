# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/binary/binary-0.4.1.ebuild,v 1.1 2007/12/15 18:37:00 dcoutts Exp $

CABAL_FEATURES="lib haddock profile"
CABAL_MIN_VERSION=1.2
inherit haskell-cabal

DESCRIPTION="Efficient, pure binary serialisation using lazy ByteStrings"
HOMEPAGE="http://code.haskell.org/binary/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4"
