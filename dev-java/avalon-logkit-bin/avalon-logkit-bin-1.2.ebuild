# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/avalon-logkit-bin/avalon-logkit-bin-1.2.ebuild,v 1.3 2004/10/16 16:59:47 axxo Exp $

inherit java-pkg

DESCRIPTION="LogKit is an easy-to-use Java logging toolkit designed for secure, performance-oriented logging."
HOMEPAGE="http://avalon.apache.org/"
MY_P=${PN/avalon-logkit/LogKit}-${PV}
MY_P=${MY_P/-bin}
SRC_URI="mirror://apache/avalon/logkit/${PV}/LogKit-${PV}-bin.tar.gz"
DEPEND=">=virtual/jre-1.3"
RDEPEND=">=virtual/jre-1.3"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 ppc sparc"
IUSE="doc"

src_install () {
	cd ${WORKDIR}/${MY_P}
	java-pkg_dojar *.jar || die "Unable to Install"
	use doc && java-pkg_dohtml -r docs/*
}
