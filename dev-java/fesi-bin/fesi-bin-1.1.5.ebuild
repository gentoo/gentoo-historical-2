# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fesi-bin/fesi-bin-1.1.5.ebuild,v 1.2 2004/10/16 17:12:42 axxo Exp $

inherit java-pkg

DESCRIPTION="JavaScript Interpreter written in Java"
SRC_URI="http://www.lugrin.ch/fesi/${PN/-bin}kit-${PV}.zip"
HOMEPAGE="http://www.lugrin.ch/fesi"
DEPEND=">=virtual/jre-1.4"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc"
KEYWORDS="~x86 ~ppc"

S=${WORKDIR}/${PN/-bin}

src_compile() { :; }

src_install() {
	java-pkg_dojar fesi.jar
	dodoc Readme.txt
	if use doc ; then
		java-pkg_dohtml -r doc/html/*
		cp -r examples ${D}/usr/share/${PN/-bin}
		cp -r tests ${D}/usr/share/${PN/-bin}
	fi
}
