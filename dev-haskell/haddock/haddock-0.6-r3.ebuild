# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/haddock/haddock-0.6-r3.ebuild,v 1.10 2005/09/15 10:39:17 kosmikus Exp $
#
# USE variable summary:
#   doc    - Build extra documenation from DocBook sources,
#               in HTML format.
#   tetex  - Build the above docs as PostScript as well.


inherit base eutils ghc-package
IUSE="doc tetex"

DESCRIPTION="A documentation tool for Haskell"
SRC_URI="http://www.haskell.org/haddock/${P}-src.tar.gz"
HOMEPAGE="http://www.haskell.org/haddock"

SLOT="0"
KEYWORDS="x86 ppc ~amd64 sparc"
LICENSE="as-is"

DEPEND="virtual/ghc
	doc? ( >=app-text/openjade-1.3.1
		>=app-text/sgml-common-0.6.3
		~app-text/docbook-sgml-dtd-3.1
		>=app-text/docbook-dsssl-stylesheets-1.64
		tetex? ( virtual/tetex
		>=app-text/jadetex-3.12 ) )"

RDEPEND=""

pkg_setup() {
	if ! has_version virtual/ghc; then
		eerror "Due to a bug in the portage dependency resolution, emerge"
		eerror "sometimes tries to merge haddock before a version of ghc"
		eerror "is available on the system. This is usually triggered when"
		eerror "you try to bootstrap ghc on a system with USE=\"doc\" using"
		eerror "the command"
		eerror
		eerror "   emerge ghc"
		eerror
		eerror "To resolve this problem, proceed in two steps. First, emerge"
		eerror "haddock (which should first pull in ghc-bin). Second, emerge"
		eerror "ghc again:"
		eerror
		eerror "   emerge haddock"
		eerror "   emerge ghc"
		die "portage dependency problem"
	fi
}

src_unpack() {
	base_src_unpack
	epatch ${FILESDIR}/${P}-gcc3.4.patch
}

src_compile() {
	# unset SGML_CATALOG_FILES because documentation installation
	# breaks otherwise ...
	SGML_CATALOG_FILES="" econf || die "econf failed"

	if $(ghc-cabal); then
		echo "SRC_HC_OPTS += -package mtl" >> mk/build.mk
	fi

	# using -j1 because -j2 behaved strangely on my machine
	emake -j1 || die "make failed"

	# if documentation has been requested, build documentation ...
	if use doc; then
		cd ${S}/haddock/doc
		emake html \
			datadir="/usr/share/doc/${PF}" \
			|| die "emake html failed"
		if use tetex; then
			emake ps \
				datadir="/usr/share/doc/${PF}" \
				|| die "emake ps failed"
		fi
	fi
}

src_install() {
	local mydoc

	# the libdir0 setting is needed for amd64, and does not
	# harm for other arches
	make install \
		prefix="${D}/usr" \
		datadir="${D}/usr/share/${P}" \
		infodir="${D}/usr/share/info" \
		mandir="${D}/usr/share/man" \
		libdir0="${D}/usr/$(get_libdir)" \
		|| die "make install failed"

	cd ${S}/haddock
	dodoc CHANGES LICENSE README TODO

	if use doc; then
		cd ${S}/haddock/doc
		dohtml -r haddock/* || die "html docs couldn't be installed"
		dosym haddock.html /usr/share/doc/${PF}/html/index.html
		if use tetex; then
			docinto ps
			dodoc haddock.ps || die "ps docs couldn't be installed"
		fi
	fi
}
