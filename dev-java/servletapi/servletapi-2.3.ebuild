# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/servletapi/servletapi-2.3.ebuild,v 1.3 2003/02/13 10:22:37 vapier Exp $

S=${WORKDIR}/jakarta-servletapi-4
DESCRIPTION="Servlet API ${PV} from jakarta.apache.org"
HOMEPAGE="http://jakarta.apache.org/"
SRC_URI="mirror://gentoo/servletapi-2.3-20021101.tar.gz"
DEPEND=">=virtual/jdk-1.3
	>=ant-1.4"
RDEPEND=">=virtual/jre-1.3"
LICENSE="Apache-1.1"
SLOT="2.3"
KEYWORDS="~x86"
IUSE="jikes"

src_compile() {
	local myc

	if [ -n "`use jikes`" ] ; then
		myc="${myc} -Dbuild.compiler=jikes"
	fi
	cd ${S}
	ANT_OPTS=${myc} ant all
}

src_install () {
	mv dist/lib/servlet.jar dist/lib/servlet-${PV}.jar
	dojar dist/lib/servlet-${PV}.jar || die "Unable to install"
	dohtml -r dist/docs/*
	dodoc dist/README.txt
}

pkg_postinst() {
	einfo "Check the servlet API Docs in /usr/share/doc/"
}
