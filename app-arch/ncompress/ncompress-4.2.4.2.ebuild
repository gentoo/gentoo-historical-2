# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/ncompress/ncompress-4.2.4.2.ebuild,v 1.4 2007/11/10 19:43:02 drac Exp $

inherit toolchain-funcs

DESCRIPTION="Another uncompressor for compatibility"
HOMEPAGE="http://ncompress.sourceforge.net/"
SRC_URI="mirror://sourceforge/ncompress/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed \
		-e 's:options= :options= $(CFLAGS) -DNOFUNCDEF -DUTIME_H $(LDFLAGS) :' \
		-e "s:CC=cc:CC=$(tc-getCC):" \
		Makefile.def > Makefile
}

src_install() {
	dobin compress || die
	dosym compress /usr/bin/uncompress
	doman compress.1
	echo '.so compress.1' > "${D}"/usr/share/man/man1/uncompress.1
	dodoc Acknowleds Changes LZW.INFO README
}
