# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/curl/curl-7.20.0-r2.ebuild,v 1.3 2010/05/08 17:49:34 jer Exp $

# NOTE: If you bump this ebuild, make sure you bump dev-python/pycurl!

inherit multilib eutils

#MY_P=${P/_pre/-}
DESCRIPTION="A Client that groks URLs"
HOMEPAGE="http://curl.haxx.se/ http://curl.planetmirror.com"
#SRC_URI="http://cool.haxx.se/curl-daily/${MY_P}.tar.bz2"
#SRC_URI="http://curl.planetmirror.com/download/${P}.tar.bz2"
SRC_URI="http://curl.haxx.se/download/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="ares gnutls idn ipv6 kerberos ldap libssh2 nss ssl test"

RDEPEND="ldap? ( net-nds/openldap )
	ssl? (
		gnutls? ( net-libs/gnutls app-misc/ca-certificates )
		nss? ( !gnutls? ( dev-libs/nss app-misc/ca-certificates ) )
		!gnutls? ( !nss? ( dev-libs/openssl ) )
	)
	idn? ( net-dns/libidn )
	ares? ( >=net-dns/c-ares-1.4.0 )
	kerberos? ( virtual/krb5 )
	libssh2? ( >=net-libs/libssh2-0.16 )"

# fbopenssl (not in gentoo) --with-spnego
# krb4 http://web.mit.edu/kerberos/www/krb4-end-of-life.html

DEPEND="${RDEPEND}
	test? (
		sys-apps/diffutils
		dev-lang/perl
	)"
# used - but can do without in self test: net-misc/stunnel

pkg_setup() {
	if ! use ssl && ( use gnutls || use nss ) ; then
		ewarn "USE='gnutls nss' are ignored without USE='ssl'."
		ewarn "Please review the local USE flags for this package."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-strip-ldflags.patch
	epatch "${FILESDIR}"/${PN}-7.19.7-test241.patch \
		"${FILESDIR}"/${P}-libcurlm4.patch
}

src_compile() {

	myconf="$(use_enable ldap)
		$(use_enable ldap ldaps)
		$(use_with idn libidn)
		$(use_with kerberos gssapi /usr)
		$(use_with libssh2)
		$(use_enable ipv6)
		$(use_enable ares)
		--enable-http
		--enable-ftp
		--enable-gopher
		--enable-file
		--enable-dict
		--enable-manual
		--enable-telnet
		--enable-smtp
		--enable-pop3
		--enable-imap
		--enable-rtsp
		--enable-nonblocking
		--enable-largefile
		--enable-maintainer-mode
		--disable-sspi
		--without-krb4
		--without-spnego"

	if use ssl ; then
		if use gnutls; then
			myconf="${myconf} --without-ssl --with-gnutls --without-nss"
			myconf="${myconf} --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt"
		elif use nss; then
			myconf="${myconf} --without-ssl --without-gnutls --with-nss"
			myconf="${myconf} --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt"
		else
			myconf="${myconf} --without-gnutls --without-nss --with-ssl"
			myconf="${myconf} --without-ca-bundle --with-ca-path=/etc/ssl/certs"
		fi
	else
		myconf="${myconf} --without-gnutls --without-nss --without-ssl"
	fi

	econf ${myconf} || die 'configure failed'

	emake || die "install failed for current version"
}

src_install() {
	emake DESTDIR="${D}" install || die "installed failed for current version"
	rm -rf "${D}"/etc/

	# https://sourceforge.net/tracker/index.php?func=detail&aid=1705197&group_id=976&atid=350976
	insinto /usr/share/aclocal
	doins docs/libcurl/libcurl.m4

	dodoc CHANGES README
	dodoc docs/FEATURES docs/INTERNALS
	dodoc docs/MANUAL docs/FAQ docs/BUGS docs/CONTRIBUTE
}
