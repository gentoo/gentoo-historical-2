# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/opencdk/opencdk-0.5.1.ebuild,v 1.4 2003/10/21 02:11:10 agriffis Exp $

DESCRIPTION="Open Crypto Development Kit for basic OpenPGP message manipulation"
HOMEPAGE="http://www.gnutls.org/"
SRC_URI="ftp://ftp.gnutls.org/pub/gnutls/opencdk/${P}.tar.bz2"

IUSE="doc"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 alpha"

RDEPEND=">=dev-libs/libgcrypt-1.1.12"

DEPEND="${RDEPEND}
		>=dev-lang/perl-5.6"

src_compile() {
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	einstall || die "installed failed"

	dodoc AUTHORS COPYING ChangeLog NEWS README \
		README-alpha THANKS TODO
	[ "`use doc`" ] && dohtml doc/opencdk-api.html
}
