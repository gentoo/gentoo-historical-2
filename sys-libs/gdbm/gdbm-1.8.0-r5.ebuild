# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
#        Chad Huneycutt <chad.huneycutt@acm.org>
# $Header: /var/cvsroot/gentoo-x86/sys-libs/gdbm/gdbm-1.8.0-r5.ebuild,v 1.18 2003/02/27 01:48:19 zwelch Exp $

inherit gnuconfig

IUSE="berkdb"

S=${WORKDIR}/${P}
DESCRIPTION="Standard GNU database libraries included for compatibility with Perl"
SRC_URI="ftp://prep.ai.mit.edu/gnu/gdbm/${P}.tar.gz"

HOMEPAGE="http://www.gnu.org/software/gdbm/gdbm.html"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha mips hppa arm"
SLOT="0"

DEPEND="virtual/glibc
	berkdb? ( =sys-libs/db-1.85-r1 )"

RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}
	patch -p0 < ${FILESDIR}/${PF}-gentoo.diff || die
	use alpha && gnuconfig_update
	use arm && gnuconfig_update
}

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info || die

	emake CFLAGS="${CFLAGS} -fomit-frame-pointer" || die
}

src_install() {
	make prefix=${D}/usr \
		man3dir=${D}/usr/share/man/man3 \
		infodir=${D}/usr/share/info \
		install || die

	make includedir=${D}/usr/include/gdbm \
		install-compat || die

	dosed "s:/usr/local/lib':/usr/lib':g" /usr/lib/libgdbm.la

	dodoc COPYING ChangeLog NEWS README
}
