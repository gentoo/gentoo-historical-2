# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-devel/autoconf/autoconf-2.13-r1.ebuild,v 1.3 2000/09/15 20:09:24 drobbins Exp $

P=autoconf-2.13      
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Used to create autoconfiguration files"
SRC_URI="ftp://prep.ai.mit.edu/gnu/autoconf/${A}"
HOMEPAGE="http://www.gnu.org/software/autoconf/autoconf.html"

src_compile() {                           
    try ./configure --prefix=/usr --host=${CHOST}
    try make
}

src_install() {                               
    into /usr
    insinto /usr/bin
    dodir /usr/bin
    insopts -m0755
    doins autoconf autoheader autoreconf autoscan autoupdate ifnames
    doinfo *.info
    dodir /usr/share/autoconf
    insinto /usr/share/autoconf
    insopts -m0644
    doins acconfig.h acfunctions acgeneral.m4 acheaders acidentifiers acmakevars acoldnames.m4 acprograms acspecific.m4 autoconf.m4 autoconf.m4f autoheader.m4 autoheader.m4f
    dodoc COPYING AUTHORS ChangeLog.* NEWS README TODO
}


