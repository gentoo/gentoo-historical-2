# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/opencdk/opencdk-0.6.6.ebuild,v 1.7 2008/01/08 17:39:37 jer Exp $

DESCRIPTION="Open Crypto Development Kit for basic OpenPGP message manipulation"
HOMEPAGE="http://www.gnutls.org/"
SRC_URI="ftp://ftp.gnutls.org/pub/gnutls/opencdk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="doc"

RDEPEND=">=dev-libs/libgcrypt-1.2.0"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.6"

src_install() {
	make DESTDIR="${D}" install || die "installed failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
	use doc && dohtml doc/opencdk-api.html
}
