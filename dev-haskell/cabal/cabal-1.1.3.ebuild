# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/cabal/cabal-1.1.3.ebuild,v 1.5 2006/02/16 13:12:03 dcoutts Exp $

CABAL_FEATURES="bootstrap lib"
inherit haskell-cabal eutils base

DESCRIPTION="Haskell Common Architecture for Building Applications and Libraries"
HOMEPAGE="http://haskell.org/cabal"
SRC_URI="http://haskell.org/cabal/release/rc/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~alpha"

IUSE="doc"

DEPEND=">=virtual/ghc-6.2"

MY_PV="${PV/_pre*/}"
S="${WORKDIR}/${PN}"

src_unpack() {
	base_src_unpack

	# Grrr, Cabal build-depends on the util package which is one of the old
	# hslibs packages. Exposing util breaks lots of things. Fortunately cabal
	# doesn't actually use anything fro util so we can remove it. A patch has
	# been sent upstream so remove this hack on the next cabal iteration.
	# Update: Seems that solving this upstream causes problems on Windows, so
	# this hack will remain for now.
	if $(ghc-cabal); then
		sed -i 's/Build-Depends: base, util/Build-Depends: base/' ${S}/Cabal.cabal
	else
		sed -i 's/Build-Depends: base, util/Build-Depends: base, unix/' ${S}/Cabal.cabal
	fi
}

src_compile() {
	if ghc-cabal; then
		make setup HC="$(ghc-getghc) -ignore-package Cabal"
	else
		make setup HC="$(ghc-getghc)"
	fi
	cabal-configure
	cabal-build
}

src_install() {
	cabal_src_install

	# documentation (install directly; generation seems broken to me atm)
	dohtml -r doc/users-guide
	if use doc; then
		dohtml -r doc/API
		dohtml -r doc/pkg-spec-html
		dodoc doc/pkg-spec.pdf
	fi
	dodoc changelog copyright README releaseNotes TODO
}

pkg_postinst () {
	if ghc-cabal && ghc-package-exists "Cabal-1.0"; then
	        ebegin "Unregistering ghc's built-in cabal "
	        $(ghc-getghcpkg) unregister "Cabal-1.0" > /dev/null
	        eend $?
	fi
	ghc-package_pkg_postinst
}

