# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgcrypt/libgcrypt-1.1.3.ebuild,v 1.4 2002/08/01 18:02:36 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="libgcrypt is a general purpose crypto library based on the code used in GnuPG."
SRC_URI="ftp://ftp.gnupg.org/gcrypt/alpha/libgcrypt/${P}.tar.gz"
HOMEPAGE="http://www.gnupg.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="app-text/jadetex
	app-text/docbook2X"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	
	local myconf
	use nls || myconf="${myconf} --disable-nls"

	econf \
		--enable-m-guard \
		--enable-static \
		${myconf} || die
	
	emake  || die
}

src_install () {
	
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS COPYING INSTALL NEWS README* THANKS VERSION 
}
