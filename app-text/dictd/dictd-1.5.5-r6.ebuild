# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Michael Conrad Tilstra <michael@gentoo.org> <tadpol@tadpol.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/dictd/dictd-1.5.5-r6.ebuild,v 1.1 2001/10/18 21:10:36 danarmak Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Dictionary Client/Server for the DICT protocol"
SRC_URI="ftp://ftp.dict.org/pub/dict/${A}"
HOMEPAGE="http://www.dict.org"

DEPEND="virtual/glibc sys-devel/gcc"

src_compile() {
    
    ./configure --prefix=/usr --mandir=/usr/share/man \
        --with-etcdir=/etc/dict --host=${CHOST} || die
    make || die
}

src_install () {
    # gotta set up the dirs for it....
    dodir /usr/bin
    dodir /usr/sbin
    dodir /usr/share/man/man1
    dodir /usr/share/man/man8

    #Now install it.
    make prefix=${D}/usr man1_prefix=${D}/usr/share/man/man1 \
             man8_prefix=${D}/usr/share/man/man8 conf=${D}/etc/dict install || die

    #Install docs
    dodoc README TODO COPYING ChangeLog ANNOUNCE
    dodoc doc/dicf.ms doc/rfc.ms doc/rfc.sh doc/rfc2229.txt
    dodoc doc/security.doc doc/toc.ms

    #conf files.
    dodir /etc/dict
    insinto /etc/dict
    doins ${FILESDIR}/${PVR}/dict.conf
    doins ${FILESDIR}/${PVR}/dictd.conf
    doins ${FILESDIR}/${PVR}/site.info

    #startups for dictd
    exeinto /etc/init.d
    newexe ${FILESDIR}/${PVR}/dictd.rc6 dictd
}

