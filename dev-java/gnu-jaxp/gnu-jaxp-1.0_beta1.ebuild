# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-jaxp/gnu-jaxp-1.0_beta1.ebuild,v 1.9 2005/02/04 17:26:15 luckyduck Exp $

inherit java-pkg

DESCRIPTION="GNU JAXP, a free implementation of SAX parser API, DOM Level 2, Sun JAXP 1.1."
HOMEPAGE="http://www.gnu.org/software/classpathx/jaxp/"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/classpathx/${PN/-/}-${PV/_beta1/beta1}.zip"
DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jdk-1.3"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="doc"

S=${WORKDIR}/${PN/-/}-${PV/_beta1/beta1}

src_compile() { :; }

src_install () {
	java-pkg_dojar gnujaxp.jar || die "Unable to Install"
	dodoc README
	use doc && java-pkg_dohtml -r apidoc/*
}
