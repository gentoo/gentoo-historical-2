# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-bootpd/netkit-bootpd-0.17-r1.ebuild,v 1.15 2002/12/09 04:33:16 manson Exp $

MY_PN=${PN/pd/paramd}
S=${WORKDIR}/${MY_PN}-${PV}
DESCRIPTION="Netkit - bootp"
SRC_URI="http://ftp.debian.org/debian/pool/main/n/netkit-bootparamd/${MY_PN}_${PV}.orig.tar.gz"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"

KEYWORDS="x86 sparc  ppc"
LICENSE="bsd"
SLOT="0"

src_compile() {
	./configure || die
	make || die
}

src_install() {
	into /usr
	dosbin rpc.bootparamd/bootparamd
	dosym bootparamd /usr/sbin/rpc.bootparamd
	doman rpc.bootparamd/bootparamd.8
	dosym bootparamd.8.gz /usr/share/man/man8/rpc.bootparamd.8.gz
	doman rpc.bootparamd/bootparams.5
	dodoc README ChangeLog
	newdoc rpc.bootparamd/README README.bootparamd
}
