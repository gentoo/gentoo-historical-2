# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Tools Team <tools@gentoo.org>
# Author: Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-j2ee/sun-j2ee-1.3.ebuild,v 1.1 2002/01/13 01:08:53 karltk Exp $

At=j2sdkee-1_3_01-linux.tar.gz
S=${WORKDIR}/j2sdkee1.3
DESCRIPTION="Sun's Java 2 Enterprise Edition Development Kit"
SRC_URI="$At"
HOMEPAGE="http://java.sun.com/j2ee/download.html#sdk"

DEPEND="virtual/glibc"
RDEPEND=">=virtual/jre-1.3"

PROVIDE="virtual/j2ee-1.3"

src_unpack() {
	if [ -f ${DISDIR}/${At} ] ; then
		die "Please download ${At} from ${HOMEPAGE}"
	fi
	unpack ${At}
}

src_install () {
	local dirs="bin lib conf config cloudscape lib images nativelib repository public_html logs help images"
	
	dodir /opt/${P}
	for i in $dirs ; do
		cp -a $i ${D}/opt/${P}/
	done
	
	dodoc LICENSE README
	dohtml -r doc/*
}

src_postinst() {
	einfo "Remember to set JAVA_HOME before running /opt/${P}/bin/j2ee"
	einfo "A set of sample configuration files (that work) can be found in /opt/${P}/conf and /opt/${P}/config"
}