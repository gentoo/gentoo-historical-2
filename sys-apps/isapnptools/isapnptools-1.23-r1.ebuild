# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/isapnptools/isapnptools-1.23-r1.ebuild,v 1.6 2002/08/01 11:59:04 seemant Exp $

A=${P}.tgz
S=${WORKDIR}/${P}
DESCRIPTION="Tools for configuring ISA PnP devices"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/system/hardware/${A}"
HOMEPAGE="http://www.roestock.demon.co.uk/isapnptools/"
KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_unpack() {
    unpack ${A}
    cd ${S}/src
    cp pnpdump_main.c pnpdump_main.c.orig
    sed -e "s/^static FILE\* o_file.*//" \
	-e "s/o_file/stdout/g" \
	-e "s/stdout_name/o_file_name/g" pnpdump_main.c.orig > pnpdump_main.c

}

src_compile() {

    ./configure --prefix=/usr --mandir=/usr/share/man --host=${CHOST} || die
    emake || die

}

src_install() {

    make DESTDIR=${D} install || die

    dodoc AUTHORS ChangeLog COPYING README NEWS
    docinto txt
    dodoc doc/README*  doc/*.txt test/*.txt
    dodoc etc/isapnp.*

    exeinto /etc/rc.d/init.d
    newexe ${FILESDIR}/isapnp.rc5 isapnp

}
