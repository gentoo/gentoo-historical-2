# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmsysmon/wmsysmon-0.7.6-r1.ebuild,v 1.8 2003/09/29 21:56:31 mholzer Exp $

S=${WORKDIR}/${P}
DESCRIPTION="WMaker DockUp to monitor: Memory usage, Swap usage, I/O
throughput, system uptime, hardware interrupts, paging and swap activity."
SRC_URI="http://www.gnugeneration.com/software/wmsysmon/src/${P}.tar.gz"
HOMEPAGE="http://www.gnugeneration.com/software/wmsysmon/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc alpha"

DEPEND="virtual/x11"

src_compile() {
	sed -i 's/^CFLAGS/#CFLAGS/' src/Makefile
	make -C src
}

src_install () {
	dobin src/wmsysmon
	dodoc COPYING ChangeLog FAQ README
}
