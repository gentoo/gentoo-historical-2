# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/mcrypt/mcrypt-2.6.4.ebuild,v 1.2 2003/08/05 18:09:37 vapier Exp $

DESCRIPTION="replacement of the old unix crypt(1)"
HOMEPAGE="http://mcrypt.hellug.gr/"
SRC_URI="ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE="nls"

DEPEND=">=dev-libs/libmcrypt-2.5.7
	>=app-crypt/mhash-0.8.15"

src_compile() {
	local myconf
	use nls || myconf="--disable-nls"
	econf ${myconf} || die "configure error"
	emake || die "make error"
}

src_install() {
	einstall || die "install error"
	dodoc README NEWS AUTHORS COPYING THANKS TODO 
}
