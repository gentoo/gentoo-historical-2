# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-timed/netkit-timed-0.17-r7.ebuild,v 1.2 2004/08/09 18:35:03 gustavoz Exp $

inherit eutils

IUSE=""
DESCRIPTION="Netkit - timed"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${P}.tar.gz"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
KEYWORDS="~x86 sparc ~ppc ~mips ~ppc64"
LICENSE="BSD"
SLOT="0"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/0.17-CFLAG-DEF-fix.patch
}

src_compile() {
	# Note this is no a autoconf configure script. econf fails
	./configure --prefix=/usr || die "bad configure"
	emake || die "bad make"
}

src_install() {
	dosbin timed/timed/timed
	doman  timed/timed/timed.8
	dosbin timed/timedc/timedc
	doman  timed/timedc/timedc.8
	dodoc  README ChangeLog BUGS

	exeinto /etc/init.d
	newexe ${FILESDIR}/timed.rc6 timed
}
