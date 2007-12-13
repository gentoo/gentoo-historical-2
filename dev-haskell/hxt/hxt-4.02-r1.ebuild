# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hxt/hxt-4.02-r1.ebuild,v 1.3 2007/12/13 17:31:46 dcoutts Exp $

inherit fixheadtails base eutils ghc-package

MY_P="HXT"
MY_PV=${MY_P}-${PV}

DESCRIPTION="A collection of tools for processing XML with Haskell"
HOMEPAGE="http://www.fh-wedel.de/~si/HXmlToolbox/"
SRC_URI="http://www.fh-wedel.de/~si/HXmlToolbox/${MY_PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND=">=dev-lang/ghc-6.2
	!>=dev-lang/ghc-6.4
	doc? ( >=dev-haskell/haddock-0.6-r2 )"
RDEPEND=">=dev-lang/ghc-6.2"

S=${WORKDIR}/${MY_PV}

src_unpack() {
	base_src_unpack
	ht_fix_file "${S}/src/Makefile"
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		emake doc || die "emake doc failed"
	fi
}

src_test() {
	make test || die "at least one test failed"
}

src_install() {
	sed -i "s:/usr/local/lib/hxt:$(ghc-libdir)/${PF}:" \
		"${S}/src/{netextra,hxt}-package.conf"
	sed -i "/ghc-pkg --update-package *$/d" "${S}/src/Makefile"

	ghc-setup-pkg "${S}/src/netextra-package.conf" "${S}/src/hxt-package.conf"
	make install \
		 GHC_INSTALL_DIR="${D}$(ghc-libdir)/${PF}" \
		 || die "make install failed"

	dodoc README
	if use doc; then
		cd "${S}/doc"
		dodoc thesis.ps
		dohtml -r *
	fi
	ghc-install-pkg
}
