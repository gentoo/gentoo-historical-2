# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-java/fesi/fesi-1.ebuild,v 1.6 2002/04/27 09:37:21 seemant Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="JavaScript Interpreter written in Java"
SRC_URI="http://home.worldcom.ch/jmlugrin/fesi/${PN}kit.zip"

DEPEND=">=virtual/jre-1.2.2"

echo $PATH
src_unpack() {
	jar -xf ${DISTDIR}/fesikit.zip
}

src_compile() {                           
	cd ${S}
}

src_install() {                               

	dojar fesi.jar

	into /usr
	dodoc COPYRIGHT.TXT Readme.txt 
	dohtml -r doc/html/*
}
