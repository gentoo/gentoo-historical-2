# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gpgme/gpgme-0.3.16.ebuild,v 1.3 2004/05/30 10:46:49 vapier Exp $

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use"
HOMEPAGE="http://www.gnupg.org/gpgme.html"
SRC_URI="ftp://ftp.gnupg.org/gcrypt/gpgme/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~ia64"
IUSE="nls crypt"

DEPEND=">=sys-libs/zlib-1.1.3
	>=app-crypt/gnupg-1.0.7
	sys-apps/gawk
	sys-devel/libtool
	sys-devel/gcc
	crypt? ( app-crypt/cryptplug )"
RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	econf `use_enable nls` || die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README README-alpha THANKS TODO VERSION
}
