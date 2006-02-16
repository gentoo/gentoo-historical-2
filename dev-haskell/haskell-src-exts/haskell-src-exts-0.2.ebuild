# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/haskell-src-exts/haskell-src-exts-0.2.ebuild,v 1.3 2006/02/16 13:27:26 dcoutts Exp $

CABAL_FEATURES="lib"
inherit base haskell-cabal

DESCRIPTION="An extension to haskell-src that handles most common syntactic extensions to Haskell"
HOMEPAGE="http://www.cs.chalmers.se/~d00nibro/haskell-src-exts/"
SRC_URI="http://www.cs.chalmers.se/~d00nibro/haskell-src-exts/haskell-src-exts-${PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/ghc
	=dev-haskell/harp-${PV}
	dev-haskell/happy"

S=${WORKDIR}/haskell-src-exts/src/haskell-src-exts

src_unpack() {
	base_src_unpack

	# Make it work with ghc pre-6.4
	sed -i 's/{-# OPTIONS_GHC /{-# OPTIONS /' \
		${S}/Language/Haskell/Hsx/Syntax.hs \
		${S}/Language/Haskell/Hsx/Pretty.hs
	sed -i 's/#ifdef __GLASGOW_HASKELL__/#if __GLASGOW_HASKELL__>=604/' \
		${S}/Language/Haskell/Hsx/Syntax.hs
}
