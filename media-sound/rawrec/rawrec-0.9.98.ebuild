# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rawrec/rawrec-0.9.98.ebuild,v 1.12 2007/01/31 20:58:29 corsair Exp $

inherit flag-o-matic toolchain-funcs

IUSE=""

DESCRIPTION="CLI program to play and record audiofiles."
HOMEPAGE="http://rawrec.sourceforge.net/"
SRC_URI="mirror://sourceforge/rawrec/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~ppc64 sparc x86"

S=${S}/src

src_compile() {
	append-ldflags -lm -lpthread
	emake CC="$(tc-getCC)" OPTFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	make EXE_DIR=${D}/usr/bin \
	MAN_DIR=${D}/usr/share/man/man1 install || die

	einfo "Removing SUID from binary.."
	chmod u-s ${D}/usr/bin/rawrec
}
