# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/curl/curl-7.12.0-r2.ebuild,v 1.4 2004/10/18 09:20:39 liquidx Exp $

# NOTE: If you bump this ebuild, make sure you bump dev-python/pycurl!

inherit eutils

DESCRIPTION="A Client that groks URLs"
HOMEPAGE="http://curl.haxx.se/"
SRC_URI="http://curl.haxx.se/download/${P}.tar.bz2"

LICENSE="MIT X11"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~mips ~alpha ~arm ~hppa ~amd64 ~ppc64 ~s390"
IUSE="ssl ipv6 ldap"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6a )
	ldap? ( net-nds/openldap )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-no-fputc.patch
}

src_compile() {
	econf \
		`use_enable ipv6` \
		`use_enable ldap` \
		`use_with ssl` \
		--enable-http \
		--enable-ftp \
		--enable-gopher \
		--enable-file \
		--enable-dict \
		--enable-manual \
		--enable-telnet \
		--enable-nonblocking \
		--enable-largefile \
		|| die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc LEGAL CHANGES README
	dodoc docs/FEATURES docs/INSTALL docs/INTERNALS docs/LIBCURL
	dodoc docs/MANUAL docs/FAQ docs/BUGS docs/CONTRIBUTE

	# backwards compat link
	dosym libcurl.so.3 /usr/$(get_libdir)/libcurl.so.2
}
