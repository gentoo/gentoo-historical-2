# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-timed/netkit-timed-0.17-r2.ebuild,v 1.3 2001/05/28 05:24:13 achim Exp $

P=netkit-timed-0.17
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Netkit - timed"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${A}"

DEPEND="virtual/glibc"

src_unpack() {
    unpack ${A}
    cp ${FILESDIR}/timed.c ${S}/timed/timed/timed.c
}

src_compile() {
    try ./configure                           
    try make
}

src_install() {                               

	into /usr
	dosbin timed/timed/timed
	doman  timed/timed/timed.8
	dosbin timed/timedc/timedc
	doman  timed/timedc/timedc.8
	dodoc  README ChangeLog BUGS
	dodir /etc/rc.d/init.d
	cp ${O}/files/timed ${D}/etc/rc.d/init.d/timed
}

pkg_config() {
 
  . /etc/rc.d/config/functions

  echo "Generating symlinks..."
  ${ROOT}/usr/sbin/rc-update add timed

}


