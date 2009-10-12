# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unlzx/unlzx-1.1.ebuild,v 1.27 2009/10/12 17:03:20 halcy0n Exp $

inherit toolchain-funcs

DESCRIPTION="Unarchiver for Amiga LZX archives"
SRC_URI="ftp://us.aminet.net/pub/aminet/misc/unix/${PN}.c.gz ftp://us.aminet.net/pub/aminet/misc/unix/${PN}.c.gz.readme"
HOMEPAGE="ftp://us.aminet.net/pub/aminet/misc/unix/${PN}.c.gz.readme"

SLOT="0"
LICENSE="freedist"
IUSE=""
KEYWORDS="alpha amd64 ~hppa ppc sparc x86"

src_unpack() {
	mkdir "${S}"
	gzip -dc "${DISTDIR}"/${PN}.c.gz > "${S}"/unlzx.c
	cp "${DISTDIR}"/${PN}.c.gz.readme  "${S}"/${PN}.c.gz.readme
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o unlzx unlzx.c || die
}

src_install() {
	dobin unlzx
	dodoc unlzx.c.gz.readme
}
