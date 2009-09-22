# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvbpsi/libdvbpsi-0.1.6.ebuild,v 1.4 2009/09/22 01:42:49 fauli Exp $

inherit eutils

IUSE="doc"

SO_VERSION=5
MY_P=${PN}${SO_VERSION}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="library for MPEG TS/DVB PSI tables decoding and generation"
HOMEPAGE="http://www.videolan.org/libdvbpsi"
SRC_URI="http://download.videolan.org/pub/${PN}/${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
# doxygen missing: ~ia64
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"

DEPEND="doc? (
		>=app-doc/doxygen-1.2.16
		media-gfx/graphviz
	)"
RDEPEND=""

pkg_setup() {
	if use doc; then
		# Making the documentation requires that /usr/bin/dot from
		# media-libs/graphviz supports PNG output.
		# This is an automagic dependency :(, Bug #181147
		# Check that /usr/bin/dot supports png by calling it with
		# an unsupported format (-Txxx) to get a list of supported formats

		if /usr/bin/dot -Txxx 2>&1 | grep -q png ; then
			# dot supports png
			:
		else
			die "You need to recompile media-gfx/graphviz with png support."
		fi
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-fbsd.patch"
}

src_compile() {
	econf --enable-release || die "econf failed"

	emake || die "emake failed"

	if use doc; then
		ewarn "Attempting to build documentation"
		emake doc || die "Could not build documentation."
	else
		ewarn "Documentation was not built"
	fi
}

src_install () {
	einstall || die "einstall failed"

	use doc && dohtml "${S}"/doc/doxygen/html/*

	cd "${S}"
	dodoc AUTHORS INSTALL README NEWS
}

pkg_postinst() {
	if has_version "<${CATEGORY}/${P}"; then
		ewarn
		ewarn "Updating libdvbpsi requires you to recompile"
		ewarn "every program using libdvbpsi."
		ewarn "You should run 'revdep-rebuild --library libdvbpsi.so.*' asap."
		ewarn
	fi
}
