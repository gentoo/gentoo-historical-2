# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/nget/nget-0.26.ebuild,v 1.2 2004/05/28 17:30:44 vapier Exp $

NPVER=20011209
DESCRIPTION="Network utility to retrieve files from an NNTP news server"
HOMEPAGE="http://nget.sourceforge.net/"
SRC_URI="mirror://sourceforge/nget/${P}+uulib.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 arm"
IUSE="static debug"

RDEPEND="virtual/glibc"
DEPEND="${RDEPEND}
	dev-libs/popt"

src_compile() {
	local myconf
#	use nls || myconf="--disable-nls"
#	use ssl && myconf="${myconf} --with-ssl"
#	use ssl || myconf="${myconf} --without-ssl --disable-opie --disable-digest"
#	use debug && myconf="${myconf} --disable-debug"
#	use ssl && CFLAGS="${CFLAGS} -I/usr/include/openssl"
	./configure \
		--prefix=/usr  \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		$myconf || die
	if use static; then
		make LDFLAGS="--static" || die
	else
		make || die
	fi
}

src_install() {
	if use build; then
		insinto /usr
		dobin ${S}/src/nget
		return
	fi
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man infodir=${D}/usr/share/info install || die
	dodoc COPYING ChangeLog FAQ README TODO .ngetrc
}
