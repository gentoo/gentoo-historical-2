# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/smixer/smixer-1.0.1.ebuild,v 1.15 2004/07/01 07:58:59 eradicator Exp $

IUSE=""

DESCRIPTION="A command-line tool for setting and viewing mixer settings"
HOMEPAGE="http://centerclick.org/programs/smixer/"
SRC_URI="http://centerclick.org/programs/smixer/${PN}${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc hppa amd64 sparc"

DEPEND="virtual/libc"

S=${WORKDIR}/${PN}

src_compile() {
	emake || die
}

src_install () {
	dodir /usr/bin /etc /usr/share/man/man1

	make \
		INS_BIN=${D}/usr/bin \
		INS_ETC=${D}/etc \
		INS_MAN=${D}/usr/share/man/man1 \
		install || die

	dodoc README
}
