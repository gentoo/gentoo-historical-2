# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libid3tag/libid3tag-0.15.0b.ebuild,v 1.6 2003/09/17 01:18:12 weeve Exp $

IUSE="debug"

S=${WORKDIR}/${P}

DESCRIPTION="The MAD id3tag library"
HOMEPAGE="http://mad.sourceforge.net"
SRC_URI="mirror://sourceforge/mad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~alpha sparc ~hppa"

DEPEND="virtual/glibc
	>=sys-libs/zlib-1.1.3"

src_compile() {
	local myconf

	myconf="--with-gnu-ld"

	use debug && myconf="${myconf} --enable-debugging" \
		|| myconf="${myconf} --disable-debugging"

	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install() {
	einstall || die "make install failed"

	dodoc CHANGES COPYRIGHT CREDITS README TODO VERSION

	# This file must be updated with every version update
	dodir /usr/lib/pkgconfig
	insinto /usr/lib/pkgconfig
	doins ${FILESDIR}/id3tag.pc
}
