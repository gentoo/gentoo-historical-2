# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fileutils/fileutils-4.1.11.ebuild,v 1.16 2004/06/28 15:54:13 vapier Exp $

DESCRIPTION="Standard GNU file utilities (chmod, cp, dd, dir, ls, etc)"
HOMEPAGE="http://www.gnu.org/software/fileutils/fileutils.html"
SRC_URI="ftp://alpha.gnu.org/gnu/fetish/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa mips"
IUSE="nls build"

DEPEND="virtual/libc
	nls? ( sys-devel/gettext )"
RDEPEND="virtual/libc"

src_unpack() {
	unpack ${A}

	cd ${S}
	# Fix braindead scripting problem in configure
	# <azarah@gentoo.org> (25 Sep 2002)
	patch -p1 < ${FILESDIR}/${P}-configure.patch || die
}

src_compile() {
	local myconf=""
	use nls || myconf="--disable-nls"

	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--bindir=/bin \
		${myconf} || die

	emake || die
}

src_install() {
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		bindir=${D}/bin \
		install || die

	cd ${D}
	dodir /usr/bin
	rm -rf usr/lib
	cd usr/bin
	ln -s ../../bin/* .

	if ! use build
	then
		cd ${S}
		dodoc AUTHORS ChangeLog* COPYING NEWS README* THANKS TODO

		#conflicts with textutils.  seems that they install the same
		#.info file between the two of them
		rm -f ${D}/usr/share/info/coreutils.info
		rmdir ${D}/usr/share/info
	else
		rm -rf ${D}/usr/share
	fi
}

