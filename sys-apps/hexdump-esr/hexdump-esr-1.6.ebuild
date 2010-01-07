# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hexdump-esr/hexdump-esr-1.6.ebuild,v 1.4 2010/01/07 21:46:25 fauli Exp $

inherit toolchain-funcs

MY_P=${P/-esr/}
DESCRIPTION="Eric Raymond's hex dumper"
HOMEPAGE="http://www.catb.org/~esr/hexdump/"
SRC_URI="http://www.catb.org/~esr/hexdump/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""
S=${WORKDIR}/${MY_P}

src_compile() {
	emake CC="$(tc-getCC) $CFLAGS" || die
	mv hexdump hexdump-esr
	mv hexdump.1 hexdump-esr.1
}

src_install() {
	dobin hexdump-esr || die
	doman hexdump-esr.1
	dodoc README
	dosym hexdump-esr /usr/bin/hex
}
