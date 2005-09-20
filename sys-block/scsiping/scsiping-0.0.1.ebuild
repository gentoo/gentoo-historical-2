# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/scsiping/scsiping-0.0.1.ebuild,v 1.2 2005/09/20 02:11:11 robbat2 Exp $

DESCRIPTION="SCSIPing pings a host on the SCSI-chain"
HOMEPAGE="http://www.vanheusden.com/Linux/"
SRC_URI="http://www.vanheusden.com/Linux/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RDEPEND="virtual/libc"
DEPEND="${RDEPEND}"

src_compile() {
	emake DEBUG=''
}

src_install() {
	dosbin scsiping
}

pkg_postinst() {
	ewarn "WARNING: using scsiping on a device with mounted partitions may be hazardous to your system!"
}
