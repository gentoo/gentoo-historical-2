# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dvhtool/dvhtool-1.0.1.ebuild,v 1.1 2003/01/23 15:47:19 tuxus Exp $

DESCRIPTION="Dvhtool is the tool responsilbe for writing the kernel(s) into the volume header"
HOMEPAGE="http://packages.debian.org/unstable/utils/dvhtool.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/d/dvhtool/dvhtool_1.0.1.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="mips"

DEPEND="virtual/glibc"
PROVIDE="virtual/bootloader"

src_unpack() {
	unpack ${A}
	cd ${S}.orig
	patch -p1 < ${FILESDIR}/dvhtool-1.0.1-2.diff || die
}
src_compile() {
	cd ${S}.orig
	econf
	emake || die "Failed to compile"
}

src_install() {
	cd ${S}.orig
	einstall

}
