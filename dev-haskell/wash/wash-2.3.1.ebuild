# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/wash/wash-2.3.1.ebuild,v 1.2 2005/03/25 00:31:05 kosmikus Exp $

inherit ghc-package

# the installation bundle is called WashNGo
MY_PN="WashNGo"
MY_P=${MY_PN}-${PV}

DESCRIPTION="WASH is a family of embedded domain-specific languages for programming Web applications"
HOMEPAGE="http://www.informatik.uni-freiburg.de/~thiemann/haskell/WASH/"
SRC_URI="http://www.informatik.uni-freiburg.de/~thiemann/haskell/WASH/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc postgres"

DEPEND=">=virtual/ghc-6.2
	!>=virtual/ghc-6.4
	postgres? ( dev-haskell/c2hs
		>=dev-db/postgresql-7.4.3 )"

S=${WORKDIR}/${MY_P}

src_compile() {
	local myopts
	myopts="${myopts} `use_enable postgres dbconnect`"
	myopts="${myopts} `use_enable doc build-docs`"
	./configure \
		--prefix="${D}usr" \
		--host=${CHOST} \
		--libdir=${D}/$(ghc-libdir) \
		${myopts} \
		--enable-register-package="${S}/$(ghc-localpkgconf)" \
			|| die "configure failed"
	make depend || die "make depend failed"
	make all || die "make all failed"
}

src_install() {
	ghc-setup-pkg
	make exec_prefix=${D}/usr install || die "make install failed"
	ghc-install-pkg
	dodoc README
	if use doc; then
		cp -r Examples ${D}/usr/share/doc/${PF}
		cd doc
		dohtml -r *
	fi
}
