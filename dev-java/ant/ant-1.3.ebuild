# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant/ant-1.3.ebuild,v 1.1 2001/04/22 17:17:44 achim Exp $

A="jakarta-ant-1.3-src.tar.gz"
S=${WORKDIR}/jakarta-ant-1.3
DESCRIPTION="Build system for java"
SRC_URI="http://jakarta.apache.org/builds/jakarta-ant/release/v1.3/src/jakarta-ant-1.3-src.tar.gz"
HOMEPAGE="http://jakarta.apache.org"

DEPEND="virtual/glibc
	>=dev-lang/jdk-1.3"


src_compile() {

  CLASSPATH=/opt/java/src.jar:/opt/java/lib/tools.jar

  export CLASSPATH
  export JAVA_HOME=/opt/java

  echo "Building ant..."
  ./bootstrap.sh
  mv bootstrap/bin .

}

src_install() {
    exeinto /opt/java/bin
    doins bin/ant bin/antRun bin/runant.pl
    insinto /opt/java/lib
    doins lib/*.jar

    dodoc LICENSE README TODO WHATSNEW
    docinto html
    cd docs
    dodoc ant_in_anger.html
    docinto html/ant2
    dodoc ant2/*.html
    docinto txt
    dodoc ant2/*.txt
    cp -a manual ${D}/usr/share/doc/${PF}/html
    prepalldocs
}



