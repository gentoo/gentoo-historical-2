# Copyright (c) Jordan Armstrong, 2002
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Jordan Armstrong <jordan@papercrane.net>
# $Header: /var/cvsroot/gentoo-x86/dev-java/log4j/log4j-1.1.3.ebuild,v 1.2 2002/04/28 04:12:40 seemant Exp $

MY_P="jakarta-${P}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="A low-overhead robust logging package for Java"
SRC_URI="http://jakarta.apache.org/log4j/${MY_P}.tar.gz"
HOMEPAGE="http://jakarta.apache.org"

DEPEND=">=virtual/jdk-1.3"

src_compile() {
	export JAVA_HOME=${JDK_HOME}
	sh build.sh jar || die
}

src_install() {
	dojar dist/lib/*.jar
	dohtml -r docs/*
}
