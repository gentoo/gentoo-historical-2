# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/ipsec-tools/ipsec-tools-0.3.1.ebuild,v 1.5 2004/06/24 22:40:57 agriffis Exp $

DESCRIPTION="IPsec-Tools is a port of KAME's IPsec utilities to the Linux-2.6 IPsec implementation."
HOMEPAGE="http://ipsec-tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~x86 ~sparc amd64"
SLOT="0"
IUSE=""
DEPEND="virtual/glibc
	>=dev-libs/openssl-0.9.6"

S=${WORKDIR}/${P}

pkg_setup() {
	my_KV=`echo ${KV} | cut -f-2 -d "."`
	if [ ${my_KV} != "2.6" ] ; then
		echo; eerror "You need a 2.6.x kernel to use the ipsec tools!"; die "You need a 2.6 kernel to use ipsec-tools!"
	fi
}

src_compile() {
	unset CC
	./configure --prefix=/usr --sysconfdir=/etc --with-kernel-headers=/usr/src/linux/include || die
	sed -e 's:AM_CFLAGS = :AM_CFLAGS = -include /usr/src/linux/include/linux/compiler.h :' -i src/setkey/Makefile || die
	sed -e 's:CPPFLAGS=:CPPFLAGS = -include /usr/src/linux/include/linux/compiler.h :' -i src/racoon/Makefile || die
	sed -e 's:va_copy:__va_copy:g' -i src/racoon/plog.c || die # GCC 2 Fix
	emake || die
}

src_install() {
	einstall || die
	rm ${D}/usr/bin
	dosbin src/racoon/racoon
	insinto /etc && doins ${FILESDIR}/ipsec.conf.sample
	insinto /etc/conf.d && newins ${FILESDIR}/racoon.conf.d racoon
	exeinto /etc/init.d && newexe ${FILESDIR}/racoon.init.d racoon

	dodoc ChangeLog README NEWS
	dodoc ${S}/src/racoon/samples/racoon.conf.sample*
}
