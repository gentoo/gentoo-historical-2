# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-rsh/netkit-rsh-0.17-r1.ebuild,v 1.5 2001/05/28 14:32:32 achim Exp $

P=netkit-rsh-0.17
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Netkit - rshd"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${A}"

DEPEND="virtual/glibc
        >=sys-libs/ncurses-5.2
	>=sys-libs/pam-0.72"

src_compile() {
    try ./configure
    cp MCONFIG MCONFIG.orig
    sed -e "s/-pipe -O2/${CFLAGS}/" -e "s:-Wpointer-arith::" MCONFIG.orig > MCONFIG
    try make
}

src_unpack () {
    unpack ${A}
    cd ${S}
    patch -p0 < ${O}/files/rlogind-auth.diff
}

src_install() {                               
	into /usr
	dobin  rcp/rcp
	doman  rcp/rcp.1
	dobin  rexec/rexec
	doman  rexec/rexec.1
	dosbin rexecd/rexecd
	dosym  rexecd /usr/sbin/in.rexecd
	doman  rexecd/rexecd.8
	dosym  rexecd.8.gz /usr/share/man/man8/in.rexecd.8.gz
	dobin  rlogin/rlogin
	doman  rlogin/rlogin.1
	dosbin rlogind/rlogind
	dosym  rlogind /usr/sbin/in.rlogind
	doman  rlogind/rlogind.8
	dosym  rlogind.8.gz /usr/share/man/man8/in.rlogind.8.gz
	dobin  rsh/rsh
	doman  rsh/rsh.1
	dosbin rshd/rshd
	dosym  rshd /usr/sbin/in.rshd
	doman  rshd/rshd.8
	dosym  rshd.8.gz /usr/share/man/man8/in.rshd.8.gz
	dodoc  README ChangeLog BUGS
	newdoc rexec/README README.rexec
	
}


