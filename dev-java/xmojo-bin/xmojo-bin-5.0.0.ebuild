# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xmojo-bin/xmojo-bin-5.0.0.ebuild,v 1.2 2004/05/03 18:19:26 karltk Exp $

inherit java-pkg

DESCRIPTION="JMX implementation for instrumenting Java/J2EE applications"
HOMEPAGE="http://www.xmojo.org/"
SRC_URI="http://www.xmojo.org/products/xmojo/downloads/XMOJO_5_0_0.tar.gz"
LICENSE="LGPL-2.1"
SLOT="5.0"
KEYWORDS="~x86"
IUSE="doc"
RDEPEND="=dev-java/crimson-1.1*
	=dev-java/xalan-2.5*
	=dev-java/gnu-jaxp-1.0*"
#	=dev-java/jetty-4.2*
S=${WORKDIR}/XMOJO

src_compile() {
	# karltk: We should really look through this package once more. It's
	# supposed to plug into a servlet container, too, so we need to test
	# it with jetty and tomcat. For now, I only use it to bootstrap
	# groovy.
	einfo "This is a binary package"
}

src_install() {
	java-pkg_dojar lib/xmojo.jar lib/xmojoadaptors.jar lib/xmojotools.jar lib/xmojoutils.jar
	java-pkg_dojar lib/AdventNetUpdateManager.jar

	if use doc ; then
		dohtml -r docs/*
	fi

	dodoc COPYRIGHT LICENSE_AGREEMENT README.html
}

