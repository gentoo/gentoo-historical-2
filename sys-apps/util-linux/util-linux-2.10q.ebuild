# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/util-linux/util-linux-2.10q.ebuild,v 1.3 2000/11/30 23:14:35 achim Exp $


S=${WORKDIR}/${P}
DESCRIPTION="Various useful Linux utilities"
SRC_URI="ftp://ftp.de.kernel.org/pub/linux/utils/util-linux/${P}.tar.bz2"
DEPEND=">=sys-libs/gpm-1.19.3
	>=sys-libs/slang-1.4.2"
RDEPEND="$DEPEND
	>=sys-apps/bash-2.04
	>=sys-devel/perl-5.6"

src_compile() {                           
	try ./configure
	try make ${MAKEOPTS} LDFLAGS=\"\"
}

src_unpack() {
    unpack ${P}.tar.bz2 
    cd ${S}
#    patch -p1 < ${FILESDIR}/util-linux-2.10o* 
    cp MCONFIG MCONFIG.orig
    sed -e "s/-pipe -O2 -m486 -fomit-frame-pointer/${CFLAGS}/" \
        -e "s/HAVE_PAM=no/HAVE_PAM=yes/" \
	-e "s/HAVE_SLN=no/HAVE_SLN=yes/" \
	-e "s/HAVE_TSORT=no/HAVE_TSORT=yes/" \
	-e "s/# HAVE_SLANG/HAVE_SLANG/" \
	-e "s/# SLANGFLAGS/SLANGSFLAGS/" \
	MCONFIG.orig > MCONFIG

}

src_install() {                               
	cd ${S}
	try make DESTDIR=${D} install
	cd ${S}
	dodoc HISTORY MAINTAINER README VERSION
	docinto licenses
	dodoc licenses/* HISTORY 
	docinto examples
	dodoc example.files/*
}


