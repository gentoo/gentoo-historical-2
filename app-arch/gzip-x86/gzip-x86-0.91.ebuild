# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/gzip-x86/gzip-x86-0.91.ebuild,v 1.2 2005/01/01 11:46:02 eradicator Exp $

inherit gcc

MY_P=${PN/-/_}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="an optimized gzip for x86 arch"
HOMEPAGE="http://www.BitWagon.com/ftp/"
SRC_URI="http://www.BitWagon.com/ftp/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""

DEPEND="virtual/libc"
PROVIDE="virtual/gzip"

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -f config.h.in
	autoheader || die
}

src_compile() {
	econf --bindir=/bin || die
	emake CCAS="$(gcc-getCC)" || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
