# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/udhcp/udhcp-0.9.9_pre20041216-r1.ebuild,v 1.4 2005/08/24 00:05:22 vapier Exp $

inherit eutils toolchain-funcs

DESCRIPTION="udhcp Server/Client Package"
HOMEPAGE="http://udhcp.busybox.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ~ppc sparc x86"
IUSE=""

DEPEND="virtual/libc"
PROVIDE="virtual/dhcpc"

S=${WORKDIR}/${PN}

pkg_setup() {
	enewgroup dhcp
	enewuser dhcp -1 -1 /var/lib/dhcp dhcp
}

src_compile() {
	emake \
		CROSS_COMPILE=${CHOST}- \
		STRIP=true \
		UDHCP_SYSLOG=1 \
		|| die
}

src_install() {
	make STRIP=true install DESTDIR="${D}" USRSBINDIR="${D}/sbin" || die
	newinitd "${FILESDIR}"/udhcp.rc udhcp
	insinto /etc
	doins samples/udhcpd.conf
	dodoc AUTHORS ChangeLog README* TODO
	newdoc samples/README README.scripts
}
