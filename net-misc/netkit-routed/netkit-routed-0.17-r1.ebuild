# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-routed/netkit-routed-0.17-r1.ebuild,v 1.5 2002/04/27 21:01:44 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Netkit - routed"
SRC_URI="http://ftp.debian.org/debian/pool/main/n/netkit-routed/${PN}_${PV}.orig.tar.gz"
HOMEPAGE="http://packages.debian.org/unstable/net/routed.html"

DEPEND=">=sys-libs/glibc-2.1.3"

src_compile() {  
	./configure	|| die
	make || die
}

src_install() {							   
	into /usr
	dosbin ripquery/ripquery
	doman  ripquery/ripquery.8
	dosbin routed/routed
	dosym routed /usr/sbin/in.routed
	doman  routed/routed.8
	dosym routed.8.gz /usr/man/man8/in.routed.8.gz
	dodoc  README ChangeLog
	newdoc routed/README README.routed
}
