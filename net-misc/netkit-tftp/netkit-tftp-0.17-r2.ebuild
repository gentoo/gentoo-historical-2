# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-tftp/netkit-tftp-0.17-r2.ebuild,v 1.5 2004/09/21 13:22:33 tgall Exp $

DESCRIPTION="the tftp server included in netkit"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/netkit-tftp-0.17.tar.gz"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"

KEYWORDS="x86 sparc ppc mips amd64 ppc64"
IUSE=""
LICENSE="BSD"
SLOT="0"

DEPEND="!virtual/tftp"
PROVIDE="virtual/tftp"

src_compile() {
	./configure --prefix=/usr --installroot=${D} || die
	emake || die
}

src_install() {
	dodir /usr/bin /usr/sbin /usr/man/man1 /usr/man/man8
	make install || die
}
