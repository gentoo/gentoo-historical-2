# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Tools Team <tools@gentoo.org>
# Author: Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-java/jndi/jndi-1.2.1-r2.ebuild,v 1.8 2002/05/01 01:41:25 seemant Exp $

At=jndi-1_2_1.zip
S=${WORKDIR}/${P}
DESCRIPTION="Java Naming and Directory Interface"
HOMEPAGE="http://java.sun.com/products/jndi/"
SRC_URI="" 

DEPEND=">=virtual/jdk-1.2"

src_unpack() {
	echo ${At}
	if [ ! -f ${DISTDIR}/${At} ] ; then
		die "You must download ${At} from ${HOMEPAGE} yourself"
	fi
	mkdir ${S}
	cd ${S}
	jar -xf ${DISTDIR}/${At}
}

src_compile() {                           
	cd ${S}
}

src_install() {           
	dojar lib/jndi.jar
	dodoc COPYRIGHT README.txt 
	dohtml -r doc/*
}
