# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/zip/zip-2.3-r2.ebuild,v 1.20 2004/06/01 22:45:07 agriffis Exp $

inherit gcc

DESCRIPTION="Info ZIP (encryption support)"
HOMEPAGE="ftp://ftp.freesoftware.com/pub/infozip/Zip.html"
SRC_URI="mirror://gentoo/${PN}${PV/./}.tar.gz
	crypt? ( ftp://ftp.icce.rug.nl/infozip/src/zcrypt29.zip )"

LICENSE="Info-ZIP"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha amd64 ia64 hppa mips"
IUSE="crypt"

DEPEND="crypt? ( app-arch/unzip )"

src_unpack() {
	unpack ${A}
	if use crypt; then
		mv -f crypt.h ${S}
		mv -f crypt.c ${S}
	fi
	cd ${S}/unix
	sed -i -e "s:-O2:${CFLAGS}:" Makefile
}

src_compile() {
	emake \
		-f unix/Makefile \
		CC="$(gcc-getCC)" \
		CPP="$(gcc-getCC) -E" \
		generic || die
}

src_install() {
	dobin zip zipcloak zipnote zipsplit
	doman man/zip.1
	dodoc BUGS CHANGES LICENSE MANUAL README TODO WHATSNEW WHERE
}
