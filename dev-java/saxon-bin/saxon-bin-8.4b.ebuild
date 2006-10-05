# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/saxon-bin/saxon-bin-8.4b.ebuild,v 1.6 2006/10/05 17:16:43 gustavoz Exp $

inherit java-pkg

DESCRIPTION="The SAXON package is a collection of tools for processing XML documents: XSLT processor, XSL library, parser."
MyPV=${PV%b}
SRC_URI="mirror://sourceforge/saxon/saxonb${MyPV/./-}.zip"
HOMEPAGE="http://saxon.sourceforge.net/"
LICENSE="MPL-1.1"
KEYWORDS="amd64 ppc x86"
IUSE="doc"
DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jdk-1.4"
SLOT="0"

S=${WORKDIR}

src_compile() { :; }

src_install() {
	use doc && java-pkg_dohtml -r doc/*
	java-pkg_dojar *.jar
}
