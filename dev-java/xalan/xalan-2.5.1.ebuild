# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xalan/xalan-2.5.1.ebuild,v 1.3 2003/10/04 01:14:37 strider Exp $

MY_P=${PN}-j_${PV//./_}

S=${WORKDIR}/${MY_P}
DESCRIPTION="XSLT processor"
HOMEPAGE="http://xml.apache.org/xalan-j/index.html"
SRC_URI="http://xml.apache.org/dist/xalan-j/${MY_P}-src.tar.gz"
LICENSE="Apache-1.1"
DEPEND=">=virtual/jdk-1.3
	>=dev-java/ant-1.5.2
	>=dev-java/xerces-2.3.0"
RDEPEND="$DEPEND"
SLOT="0"
KEYWORDS="x86 ~sparc ~ppc"
IUSE="doc"

src_compile() {
	CLASSPATH=$CLASSPATH:`pwd`/bin/xercesImpl.jar:`pwd`/bin/bsf.jar:`pwd`/src\
	ant jar ${myc} || die "build failed"

	if [ -n "`use doc`" ] ; then
		if [ `java-config --java-version 2>&1 | grep "1\.4\."  | wc -l` -lt 1 ]  ; then
			ant javadocs || die "Build Javadocs Failed"
		else
			USE=""
			einfo "                                                          "
			einfo " 1.4.x JDKs are unable to compile Javadocs at this time.  "
			einfo "                                                          "
		fi
	fi
}

src_install () {
	dojar build/xalan.jar
	dohtml readme.html

	if [ -n "`use doc`" ] ; then
		dohtml -r build/docs/*
	fi
}

pkg_postinst() {
	if [ -n "`use doc`" ] ; then
		einfo "                                                          "
		einfo " API Documentation is in /usr/share/doc/${PN}-${PV}.      "
		einfo "                                                          "
		einfo " Design documentation can be found online at:             "
		einfo "     http://xml.apache.org/xalan-j/design/design2_0_0.html"
		einfo "                                                          "
		sleep 5
	else
		einfo "                                                          "
		einfo " Online Documentation:                                    "
		einfo "     http://xml.apache.org/xalan-j/design/design2_0_0.html"
		einfo "     http://xml.apache.org/xalan-j/apidocs/index.html     "
		einfo "                                                          "
		sleep 5
	fi
}
