# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Bruce A. Locke <blocke@shivan.org>
# $Header: /var/cvsroot/gentoo-x86/dev-util/usermode/usermode-20020104.ebuild,v 1.1 2002/01/06 10:52:16 blocke Exp $

S=${WORKDIR}/tools
DESCRIPTION="Tools for use with Usermode Linux virtual machines"
SRC_URI="http://prdownloads.sourceforge.net/user-mode-linux/uml_utilities_20020104.tar.bz2"
HOMEPAGE="http://user-mode-linux.sourceforge.net/"

DEPEND=""
#RDEPEND=""

src_compile() {

	make CFLAGS="${CFLAGS} -D_LARGEFILE64_SOURCE -g -Wall" all
}

src_install () {

	mv port-helper/Makefile port-helper/Makefile.orig
	sed -e 's/\/usr\/lib\/uml/\/usr\/bin/' port-helper/Makefile.orig > port-helper/Makefile

	make DESTDIR=${D} install

	dodoc COPYING 	
}
