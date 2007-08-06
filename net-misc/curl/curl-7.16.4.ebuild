# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/curl/curl-7.16.4.ebuild,v 1.4 2007/08/06 03:48:49 kumba Exp $

# NOTE: If you bump this ebuild, make sure you bump dev-python/pycurl!

inherit autotools eutils

#MY_P=${P/_pre/-}
DESCRIPTION="A Client that groks URLs"
HOMEPAGE="http://curl.haxx.se/ http://curl.planetmirror.com"
#SRC_URI="http://cool.haxx.se/curl-daily/${MY_P}.tar.bz2"
SRC_URI="http://curl.haxx.se/download/${P}.tar.bz2"

LICENSE="MIT X11"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="ssl ipv6 ldap ares gnutls nss idn kerberos test"

RDEPEND="gnutls? ( net-libs/gnutls )
	nss? ( !gnutls? ( dev-libs/nss ) )
	ssl? ( !gnutls? ( !nss? ( dev-libs/openssl ) ) )
	ldap? ( net-nds/openldap )
	idn? ( net-dns/libidn )
	ares? ( >=net-dns/c-ares-1.4.0 )
	kerberos? ( virtual/krb5 )
	app-misc/ca-certificates"

# net-libs/libssh2 (masked) --with-libssh2
# fbopenssl (not in gentoo) --with-spnego
# krb4 http://web.mit.edu/kerberos/www/krb4-end-of-life.html

DEPEND="${RDEPEND}
	test? (
		sys-apps/diffutils
		dev-lang/perl
	)"
# used - but can do without in self test: net-misc/stunnel
#S="${WORKDIR}"/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
#	epatch "${FILESDIR}"/${P}-strip-ldflags.patch
	epatch "${FILESDIR}"/curl-7.16.2-strip-ldflags.patch
	elibtoolize
}

src_compile() {

	myconf="$(use_enable ldap)
		$(use_with idn libidn)
		$(use_enable kerberos gssapi)
		$(use_enable ipv6)
		--enable-http
		--enable-ftp
		--enable-gopher
		--enable-file
		--enable-dict
		--enable-manual
		--enable-telnet
		--enable-nonblocking
		--enable-largefile
		--enable-maintainer-mode
		--disable-sspi
		--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt
		--without-krb4
		--without-libssh2
		--without-spnego"

	if use ipv6 && use ares; then
		elog "c-ares support disabled because it is incompatible with ipv6."
		myconf="${myconf} --disable-ares"
	else
		myconf="${myconf} $(use_enable ares)"
	fi

	if use gnutls; then
		myconf="${myconf} --without-ssl --with-gnutls --without-nss"
	elif use nss; then
		myconf="${myconf} --without-ssl --without-gnutls --with-nss"
	elif use ssl; then
		myconf="${myconf} --without-gnutls --without-nss --with-ssl"
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

pkg_postinst() {
	if [[ -e "${ROOT}"/usr/$(get_libdir)/libcurl.so.3 ]] ; then
		elog "You must re-compile all packages that are linked against"
		elog "curl-7.15.* by using revdep-rebuild from gentoolkit:"
		elog "# revdep-rebuild --library libcurl.so.3"
	fi
}
