# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unzip/unzip-5.50.ebuild,v 1.9 2004/02/22 05:50:29 mr_bones_ Exp $

DESCRIPTION="Unzipper for pkzip-compressed files"
HOMEPAGE="ftp://ftp.info-zip.org/pub/infozip/UnZip.html"
SRC_URI="ftp://ftp.info-zip.org/pub/infozip/src/${PN}${PV/.}.tar.gz"

LICENSE="Info-ZIP"
SLOT="0"
KEYWORDS="x86 ppc alpha"

DEPEND="virtual/glibc"

src_compile() {
	sed -i -e "s:-O3:${CFLAGS}:" unix/Makefile

	use x86 \
		&& TARGET=linux \
		|| TARGET=linux_noasm

	make -f unix/Makefile $TARGET || die
}

src_install() {
	dobin unzip funzip unzipsfx unix/zipgrep
	doman man/*.1
	dodoc BUGS COPYING History* LICENSE README ToDo WHERE
}
