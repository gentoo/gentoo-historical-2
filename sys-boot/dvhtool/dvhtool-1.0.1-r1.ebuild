# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/dvhtool/dvhtool-1.0.1-r1.ebuild,v 1.1 2005/09/25 05:53:33 kumba Exp $

inherit eutils

DESCRIPTION="Dvhtool is the tool responsible for writing MIPS kernel(s) into the SGI volume header"
HOMEPAGE="http://packages.debian.org/unstable/utils/dvhtool.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/d/dvhtool/dvhtool_1.0.1.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~x86 mips"
IUSE=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}.orig

	# several applicable hunks from a debian patch
	epatch ${FILESDIR}/${P}-debian.diff

	# Allow dvhtool to recognize Linux RAID and Linux LVM partitions
	epatch ${FILESDIR}/${P}-1.0.1-add-raid-lvm-parttypes.patch
}

src_compile() {
	cd ${S}.orig
	econf || die "econf failed"
	emake || die "Failed to compile"
}

src_install() {
	cd ${S}.orig
	einstall
}
