# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libelf/libelf-0.7.0.ebuild,v 1.8 2002/12/09 04:21:03 manson Exp $

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="A ELF object file access library"
SRC_URI="http://www.stud.uni-hannover.de/~michael/software/libelf-0.7.0.tar.gz"
HOMEPAGE="http://www.stud.uni-hannover.de/~michael/software/"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="x86 sparc "

DEPEND="nls?  ( sys-devel/gettext )"

src_compile() {
	local myconf

	use nls || myconf="--disable-nls"
	
	econf \
		--enable-shared \
		${myconf} || die
		
	emake || die
}

src_install () {
	make prefix=${D}/usr \
		install || die
		
	dodoc COYPING.LIB CHangeLog VERSION README
}
