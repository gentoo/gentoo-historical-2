# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/watchfolder/watchfolder-0.3.3.ebuild,v 1.6 2008/10/27 22:45:33 mr_bones_ Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Watches directories and processes files, similar to the watchfolder option of Acrobat Distiller."
HOMEPAGE="http://freshmeat.net/projects/watchd/"
SRC_URI="http://dstunrea.sdf-eu.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE=""
DEPEND=""

S="${WORKDIR}/${P/folder/d}"

src_unpack() {
	unpack ${A}
	cd ${S}

	# patch to remove warnings on 64 bit systems
	epatch ${FILESDIR}/${PV}-64bit.patch || die

	sed -i \
		-e '/-c -o/s:OPT:CFLAGS:' \
		-e 's:(\(LD\)\?OPT):(LDFLAGS) $(CFLAGS):' \
		-e 's:gcc:$(CC):' \
		Makefile || die "sed Makefile failed"
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin watchd
	insinto /etc
	doins watchd.conf
	dodoc README doc/*
}
