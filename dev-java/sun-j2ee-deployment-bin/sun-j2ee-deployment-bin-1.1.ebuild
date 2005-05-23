# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-j2ee-deployment-bin/sun-j2ee-deployment-bin-1.1.ebuild,v 1.2 2005/05/23 15:51:51 luckyduck Exp $

inherit java-pkg

MY_PV=${PV/./_}

DESCRIPTION="J2EE Application Deployment Specification"
HOMEPAGE="http://java.sun.com/j2ee/tools/deployment/"
SRC_URI="http://dev.gentoo.org/~karltk/projects/java/distfiles/j2ee_deployment-${MY_PV}-fr-class.zip
	doc? ( http://dev.gentoo.org/~karltk/projects/java/distfiles/j2ee_deployment-${MY_PV}-fr-doc.zip )"
LICENSE="sun-bcla-j2ee-deployment"
SLOT="1.1"
KEYWORDS="~x86 ~amd64"
IUSE="doc"
DEPEND="virtual/jdk"
RDEPEND="virtual/jre"
S=${WORKDIR}

src_compile() {
	jar cvf ${PN}.jar javax
}

src_install() {

	use doc && java-pkg_dohtml -r doc/*
	dojar ${PN}.jar
}
