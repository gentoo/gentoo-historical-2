# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mtd/mtd-20040808.ebuild,v 1.3 2005/01/23 22:30:41 solar Exp $

DESCRIPTION="JFFS2 is a log-structured file system designed for use on flash devices in embedded systems."
HOMEPAGE="http://sources.redhat.com/jffs2/"
SRC_URI="ftp://ftp.uk.linux.org/pub/people/dwmw2/mtd/cvs/${PN}-snapshot-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~mips ~arm ~amd64"
IUSE=""

S=${WORKDIR}/${PN}

DEPEND="sys-libs/zlib
	virtual/libc"

src_unpack() {
	unpack ${A}
	sed -i -e s:'-O2 -Wall':"${CFLAGS}":g ${S}/util/Makefile || die
}

src_compile() {
	cd ${S}/util
	emake LINUXDIR=${ROOT}/usr/src/linux/ || die
}

src_install() {
	cd ${S}/util
	einstall DESTDIR=${D}
}
