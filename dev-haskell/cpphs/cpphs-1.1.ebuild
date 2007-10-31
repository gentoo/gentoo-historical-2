# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/cpphs/cpphs-1.1.ebuild,v 1.7 2007/10/31 12:54:50 dcoutts Exp $

CABAL_FEATURES="bin"
inherit eutils haskell-cabal

DESCRIPTION="A liberalised cpp-a-like preprocessor for Haskell"
HOMEPAGE="http://haskell.org/cpphs/"
SRC_URI="http://www.cs.york.ac.uk/fp/cpphs/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="dev-lang/ghc"
RDEPEND=""

src_install() {
	cabal_src_install
	dohtml docs/index.html
	doman docs/cpphs.1
}
