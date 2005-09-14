# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/dcd/dcd-0.95.ebuild,v 1.14 2005/09/14 07:15:06 agriffis Exp $

IUSE=""

S=${WORKDIR}/dcd-0.95
DESCRIPTION="A simple command-line based CD Player"
HOMEPAGE="http://www.technopagan.org/dcd"
SRC_URI="http://www.technopagan.org/dcd/dcd-0.95.tar.bz2"

DEPEND="virtual/libc"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="alpha amd64 ~ppc ppc64 sparc x86"

src_unpack() {

	unpack ${A}
	cd ${S}
	cp Makefile Makefile.orig
	sed -e "s:PREFIX = .*$:PREFIX = \"${D}/usr\":" \
		-e "s:/man/:/share/man/:" \
		-e "s:# CDROM = /dev/cdroms/cdrom0:CDROM = \"/dev/cdroms/cdrom0\":"\
		-e "/install -m 755 -d \${HOME}\/\${CDI}/d"\
		Makefile.orig > Makefile

}

src_compile() {

	make EXTRA_CFLAGS="$CFLAGS" || die

}

src_install() {

	make PREFIX=${D}/usr install || die
	dodoc README BUGS ChangeLog

}
