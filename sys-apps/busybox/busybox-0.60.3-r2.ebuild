# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/busybox/busybox-0.60.3-r2.ebuild,v 1.6 2004/06/30 14:32:31 agriffis Exp $

inherit eutils

DESCRIPTION="Utilities for rescue and embedded systems"
HOMEPAGE="http://www.busybox.net/"
SRC_URI="http://www.busybox.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* sparc -amd64"
IUSE="static"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cp ${FILESDIR}/Config.h-${PV}-cd ${S}/Config.h
	# fix for sparc lag/flush in ash
	cd ${S}
	epatch ${FILESDIR}/${PN}-cmdedit-sparc.diff
	# I did not include the msh patch since I don't know if it will
	# break stuff, I compile ash anyway, and it's in CVS
}

src_compile() {
	local myconf
	use static && myconf="${myconf} DOSTATIC=true"
	emake ${myconf} || die
}

src_install() {
	into /
	dobin busybox
	into /usr
	dodoc AUTHORS Changelog* INSTALL LICENSE README TODO

	docinto scripts
	dodoc busybox.links

	cd docs
	doman *.1
	docinto txt
	dodoc *.txt
	docinto pod
	dodoc *.pod
	dohtml *.html
	dohtml *.sgml

	cd ../scripts
	docinto scripts
	dodoc inittab
	dodoc depmod.pl
}
