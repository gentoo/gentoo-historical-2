# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Nicholas Jones <carpaski@twobit.net>
# Maintainer: Nicholas Jones <carpaski@twobit.net>
# $Header: /var/cvsroot/gentoo-x86/app-text/manedit/manedit-0.5.6-r1.ebuild,v 1.1 2002/05/14 15:42:31 tod Exp $

S=${WORKDIR}/${P}

DESCRIPTION="Man page editor using XML tags"

SRC_URI="ftp://wolfpack.twu.net/users/wolfpack/${P}.tar.bz2"

HOMEPAGE="http://wolfpack.twu.net/ManEdit"

LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/glibc
	virtual/x11
	x11-libs/gtk+
	sys-libs/zlib
	sys-apps/bzip2"

RDEPEND=${DEPEND}


src_compile() {

	# It autodetects x86 processors and adds the -march option itself
	# but we don't actually want that.
	env CFLAGS="${CFLAGS}" ./configure Linux \
		--prefix=/usr \
		--enable=bzip2 \
		--enable=zlib \
		--disable="arch-i486" \
		--disable="arch-i586" \
		--disable="arch-i686" \
		--disable="arch-pentiumpro" || die "Bad Configure"
	
	emake || die "Compile Error"
}

src_install() {
	make PREFIX=${D}/usr install || die "make install failed."
	dodoc AUTHORS LICENSE README
}
