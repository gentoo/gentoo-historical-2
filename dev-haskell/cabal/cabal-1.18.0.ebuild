# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/cabal/cabal-1.18.0.ebuild,v 1.1 2013/09/09 20:10:58 slyfox Exp $

EAPI=5

CABAL_FEATURES="bootstrap lib profile test-suite"
inherit eutils haskell-cabal versionator

if [[ ${PV} == *9999* ]]; then
	LIVE_EBUILD=yes
	inherit git-2
fi

MY_PN=Cabal
MY_P=${MY_PN}-${PV}

DESCRIPTION="A framework for packaging Haskell software"
HOMEPAGE="http://www.haskell.org/cabal/"
EGIT_REPO_URI="git://github.com/haskell/cabal.git"

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="doc"

if [[ -n ${LIVE_EBUILD} ]]; then
	# Cabal's subdir
	EGIT_SOURCEDIR=${S}
	S="${S}"/${MY_PN}
else
	SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

RDEPEND=">=dev-lang/ghc-6:="
DEPEND="${RDEPEND}
		test? ( dev-haskell/extensible-exceptions
			dev-haskell/hunit
			>=dev-haskell/quickcheck-2.1.0.1
			dev-haskell/regex-posix
			dev-haskell/test-framework
			dev-haskell/test-framework-hunit
			>=dev-haskell/test-framework-quickcheck2-0.2.12
		)"

src_prepare() {
	if [[ -n ${LIVE_EBUILD} ]]; then
		CABAL_FILE=${MY_PN}.cabal cabal_chdeps 'version: 1.17.0' "version: ${PV}"
	fi
}

src_configure() {
	cabal-is-dummy-lib && return

	einfo "Bootstrapping Cabal..."
	$(ghc-getghc) ${HCFLAGS} -i -i. -i"${WORKDIR}/${FP_P}" -cpp --make Setup.hs \
		-o setup || die "compiling Setup.hs failed"
	cabal-configure
}

src_compile() {
	cabal-is-dummy-lib && return

	cabal-build
}
