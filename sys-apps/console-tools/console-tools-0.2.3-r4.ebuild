# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/console-tools/console-tools-0.2.3-r4.ebuild,v 1.2 2001/08/09 18:05:42 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Console and font utilities"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/system/keyboards/${P}.tar.gz"
HOMEPAGE="http://altern.org/ydirson/en/lct/"

DEPEND="virtual/glibc
        sys-devel/autoconf sys-devel/automake sys-devel/libtool
        nls? ( sys-devel/gettext )"
RDEPEND="virtual/glibc"

src_unpack() {

	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/${P}.patch

    patch -p0 < ${FILESDIR}/${P}-po-Makefile.in.in-gentoo.diff
	try aclocal
	try libtoolize --force -c
	try autoheader
	try automake -c
	try autoconf
}

src_compile() {

	local myconf

	if [ "$DEBUG" ]
        then
	  myconf="--enable-debugging"
	fi
    if [ -z "`use nls`" ]
    then
      myconf="${myconf} --disable-nls"
    fi

	try ./configure --prefix=/usr --mandir=/usr/share/man --host=${CHOST} ${myconf}
	try make $MAKEOPTS all
}

src_install() {

    # DESTDIR does not work correct
    try make DESTDIR=${D} install
    
	if [ -z "`use bootcd`" ]
	then
		dodoc BUGS COPYING* CREDITS ChangeLog NEWS README RELEASE TODO
		docinto txt
		dodoc doc/*.txt doc/README.*
		docinto sgml
		dodoc doc/*.sgml
		docinto txt/contrib
		dodoc doc/contrib/*
		docinto txt/dvorak
		dodoc doc/dvorak/*
		docinto txt/file-formats
		dodoc doc/file-formats/*
		doman doc/man/*.[1-8]
	else
		rm -rf ${D}/usr/share ${D}/usr/include ${D}/usr/lib/lib*.{a,la}
	fi
}
