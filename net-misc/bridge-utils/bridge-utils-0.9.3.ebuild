# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Donny Davies <woodchip@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/bridge-utils/bridge-utils-0.9.3.ebuild,v 1.1 2001/12/05 20:31:32 woodchip Exp $

# I think you want CONFIG_BRIDGE in your kernel to use this ;)

DESCRIPTION="Tools for configuring the Linux kernel 802.1d Ethernet Bridge"
HOMEPAGE="http://bridge.sourceforge.net/"

S=${WORKDIR}/${PN}
SRC_URI="http://bridge.sourceforge.net/bridge-utils/${P}.tar.gz"

DEPEND="virtual/glibc"

src_compile() {

	make CFLAGS="${CFLAGS}" || die "compile problem"
}

src_install () {

	dosbin brctl/brctl
	doman doc/brctl.8

	insinto /usr/include ; doins libbridge/libbridge.h
	insinto /usr/lib ; doins libbridge/libbridge.a

	dodoc AUTHORS COPYING ChangeLog README THANKS
	dodoc doc/{FAQ,FIREWALL*,HOWTO,PROJECTS,SMPNOTES,TODO,WISHLIST}
}
