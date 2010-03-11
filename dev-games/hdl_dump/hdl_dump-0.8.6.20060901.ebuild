# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/hdl_dump/hdl_dump-0.8.6.20060901.ebuild,v 1.2 2010/03/11 23:14:44 sping Exp $

inherit toolchain-funcs versionator

MY_PV=$(replace_version_separator 3 -)
DESCRIPTION="game installer for playstation 2 HD Loader"
HOMEPAGE="http://www.psx-scene.com/hdldump/"
SRC_URI="http://www.psx-scene.com/hdldump/hdl_dumx-${MY_PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s/-O0 -g/${CFLAGS}/" \
		-e "s/@\$(CC)/$(tc-getCC)/" \
		-e '/LDFLAGS =/d' \
		Makefile || die "sed failed"
}

src_install() {
	dobin hdl_dump || die "dobin failed"
	dodoc AUTHORS CHANGELOG README TODO
}
