# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/time/time-1.7-r1.ebuild,v 1.13 2003/06/21 21:19:41 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A command that displays info about resources used by a program"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/time/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/directory/time.html"
KEYWORDS="x86 amd64 ppc sparc arm"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_compile() {
	./configure --prefix=/usr \
		--mandir=/usr/share/man || die
	emake || die
}

src_install() {
	cd ${S}
	echo "START-INFO-DIR-ENTRY
* time: (time).            summarize system resources used
END-INFO-DIR-ENTRY" > temp
	sed -e '/^trans/r temp' < time.info > time.info.new
	mv time.info.new time.info

	make prefix=${D}/usr sysconfdir=${D}/etc mandir=${D}/usr/share/man install || die
	gzip -9 ${D}/usr/info/time.info
	dodoc ChangeLog COPYING README
	dodoc AUTHORS NEWS
}
