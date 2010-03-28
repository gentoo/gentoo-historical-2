# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/darcs/darcs-2.4.ebuild,v 1.1 2010/03/28 21:40:12 kolmodin Exp $

EAPI="2"
CABAL_FEATURES="bin lib profile haddock"
inherit haskell-cabal eutils bash-completion

DESCRIPTION="a distributed, interactive, smart revision control system"
HOMEPAGE="http://darcs.net/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="doc"

# keywording notes:
# many packages needs extensible-exceptions, thus ghc 6.10 or higher.
# the result is that we had to drop a few arches from KEYWORDS until we have
# arranged ghc binaries for those arches.

# Dependency notes:
# 1) Use a cunning trick for hashed-storage, haskeline, regex-compat
#       where the min bound is the lowest version available.
# 2) Do the opposite for zlib: highest not available.
# 3) Prefer curl over HTTP since darcs uses an old version of HTTP.
# 4) Use the same bounds for mmap as hashed-storage.

COMMONDEPS=">=dev-lang/ghc-6.6.1
		=dev-haskell/hashed-storage-0.4*
		=dev-haskell/haskeline-0.6*
		=dev-haskell/html-1.0*
		=dev-haskell/mmap-0.4*
		<dev-haskell/mtl-1.2
		=dev-haskell/network-2.2*
		dev-haskell/parsec:0
		<dev-haskell/regex-compat-0.94
		=dev-haskell/terminfo-0.3*
		=dev-haskell/utf8-string-0.3*
		<dev-haskell/zlib-0.6.0.0
		net-misc/curl"

DEPEND="${COMMONDEPS}
		>=dev-haskell/cabal-1.6
		doc?  ( virtual/latex-base
				dev-tex/latex2html )"

# darcs also has a library version; we thus need $DEPEND
RDEPEND="${COMMONDEPS}
		virtual/mta"

pkg_setup() {
	if use doc && ! built_with_use -o dev-tex/latex2html png gif; then
		eerror "Building darcs with USE=\"doc\" requires that"
		eerror "dev-tex/latex2html is built with at least one of"
		eerror "USE=\"png\" and USE=\"gif\"."
		die "USE=doc requires dev-tex/latex2html with USE=\"png\" or USE=\"gif\""
	fi
}

src_prepare() {
	pushd "contrib"
	epatch "${FILESDIR}/${PN}-1.0.9-bashcomp.patch"
	popd

	# We don't have threaded ghc builds at least for those platforms,
	# so it won't just work.
	# Beware: http://www.haskell.org/ghc/docs/latest/html/users_guide/options-phases.html#options-linker
	# contains: 'The ability to make a foreign call that does not block all other Haskell threads.'
	# It might have interactivity impact.
	if use alpha || use hppa || use ppc64 ; then
		sed -i 's/-threaded//g' "${S}/darcs.cabal" || die "Unable to sed -threaded out."
	fi
}

src_configure() {
	# Use curl for net stuff to avoid strict version dep on HTTP and network

	cabal_src_configure \
		--flags=curl \
		--flags=-http \
		--flags=curl-pipelining \
		--flags=color \
		--flags=terminfo \
		--flags=mmap
}

src_install() {
	cabal_src_install
	dobashcompletion "${S}/contrib/darcs_completion" "${PN}"

	# fixup perms in such an an awkward way
	mv "${D}/usr/share/man/man1/darcs.1" "${S}/darcs.1" || die "darcs.1 not found"
	doman "${S}/darcs.1" || die "failed to register darcs.1 as a manpage"
}

pkg_postinst() {
	ghc-package_pkg_postinst
	bash-completion_pkg_postinst

	ewarn "NOTE: in order for the darcs send command to work properly,"
	ewarn "you must properly configure your mail transport agent to relay"
	ewarn "outgoing mail.  For example, if you are using ssmtp, please edit"
	ewarn "/etc/ssmtp/ssmtp.conf with appropriate values for your site."
}
