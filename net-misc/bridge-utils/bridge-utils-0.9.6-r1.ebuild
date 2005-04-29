# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/bridge-utils/bridge-utils-0.9.6-r1.ebuild,v 1.7 2005/04/29 23:00:09 robbat2 Exp $

# I think you want CONFIG_BRIDGE in your kernel to use this ;)

DESCRIPTION="Tools for configuring the Linux kernel 802.1d Ethernet Bridge"
HOMEPAGE="http://bridge.sourceforge.net/"

S=${WORKDIR}/${PN}
SRC_URI="mirror://sourceforge/bridge/${P}.tar.gz"

IUSE=""
DEPEND="virtual/libc"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

src_compile() {
	econf --prefix=/ --libdir=/usr/lib --includedir=/usr/include || die "econf failed"
	emake || die "make failed"
}

src_install () {
	einstall prefix=${D} libdir=${D}/usr/lib includedir=${D}/usr/include
	dodoc AUTHORS ChangeLog README THANKS
	dodoc doc/{FAQ,FIREWALL,HOWTO,PROJECTS,SMPNOTES,WISHLIST}

	exeinto /etc/init.d
	newexe ${FILESDIR}/bridge.rc bridge

	insinto /etc/conf.d
	newins ${FILESDIR}/bridge.conf bridge
}

pkg_postinst () {
	ewarn "Gentoo now comes with a bridge init script. You can add it to"
	ewarn "the boot runlevel. You can configure it in /etc/conf.d/bridge"
}
