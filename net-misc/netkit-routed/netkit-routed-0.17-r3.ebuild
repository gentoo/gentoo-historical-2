# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-routed/netkit-routed-0.17-r3.ebuild,v 1.5 2004/07/15 03:07:27 agriffis Exp $

DESCRIPTION="Netkit - routed"
SRC_URI="mirror://debian/pool/main/n/netkit-routed/${PN}_${PV}.orig.tar.gz"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"

KEYWORDS="x86 sparc ppc mips alpha"
IUSE=""
LICENSE="BSD"
SLOT="0"

src_compile() {
	./configure || die
	make || die
}

src_install() {
	into /usr

	# ripquery
	dosbin ripquery/ripquery
	doman ripquery/ripquery.8

	# routed
	dosbin routed/routed
	dosym routed /usr/sbin/in.routed
	doman routed/routed.8
	dosym routed.8.gz /usr/share/man/man8/in.routed.8.gz

	# docs
	dodoc README ChangeLog
	newdoc routed/README README.routed

	# init scripts
	insinto /etc/conf.d
	newins "${FILESDIR}/routed.confd" routed
	exeinto /etc/init.d
	newexe "${FILESDIR}/routed.initd" routed
}
