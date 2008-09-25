# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/libggz/libggz-0.0.14.1.ebuild,v 1.7 2008/09/25 15:51:45 jer Exp $

inherit games-ggz

DESCRIPTION="The GGZ library, used by GGZ Gaming Zone"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE="debug gnutls"

DEPEND="dev-libs/libgcrypt
	gnutls? ( net-libs/gnutls )
	!gnutls? ( dev-libs/openssl )"

src_compile() {
	games-ggz_src_compile \
		--with-gcrypt \
		--with-tls=$(use gnutls && echo GnuTLS || echo OpenSSL)
}
