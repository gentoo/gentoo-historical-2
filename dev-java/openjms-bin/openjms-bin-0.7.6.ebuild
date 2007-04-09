# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/openjms-bin/openjms-bin-0.7.6.ebuild,v 1.14 2007/04/09 11:38:21 betelgeuse Exp $

DESCRIPTION="Open Java Messaging System"
HOMEPAGE="http://openjms.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/-bin/}/${P/-bin/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc64 ppc"
IUSE="doc"

DEPEND=""
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${PN/-bin/}-${PV}

src_compile() { :; }

src_install() {
	dodir /opt/${PN/-bin/}
	cp -r {bin,config,lib} ${D}/opt/${PN/-bin/}/
	use doc && cp -r {docs,src} ${D}/opt/${PN/-bin/}/

	fperms 755 /opt/${PN/-bin/}/bin/*
	newenvd ${FILESDIR}/${PV}/10${P/-bin/} 10${PN/-bin/}
	newinitd ${FILESDIR}/${PV}/rc2 openjms
	newconfd ${FILESDIR}/${PV}/conf openjms
}
