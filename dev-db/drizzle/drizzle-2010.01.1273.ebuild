# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/drizzle/drizzle-2010.01.1273.ebuild,v 1.1 2010/01/29 10:30:15 flameeyes Exp $

EAPI=2

inherit flag-o-matic libtool autotools eutils

DESCRIPTION="Drizzle project"
HOMEPAGE="http://drizzle.org"
SRC_URI="http://launchpad.net/drizzle/trunk/bell/+download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

# don't add an ssl USE flag here, since it's not ssl support that
# we're to use, but rather MD5 support
IUSE="debug tcmalloc doc memcache curl pam gearman gnutls openssl"

# upstream bug #499911
RESTRICT="memcache? ( test ) !curl? ( test )"

RDEPEND="tcmalloc? ( dev-util/google-perftools )
		dev-db/libdrizzle
		sys-libs/readline
		sys-apps/util-linux
		dev-libs/libpcre
		dev-libs/libevent
		dev-libs/protobuf
		gearman? ( sys-cluster/gearmand )
		pam? ( sys-libs/pam )
		curl? ( net-misc/curl )
		gnutls? ( net-libs/gnutls )
		memcache? ( dev-libs/libmemcached )"
DEPEND="${RDEPEND}
		dev-util/gperf
		doc? ( app-doc/doxygen )"
RDEPEND="${RDEPEND}
		curl? (
			gnutls? ( net-misc/curl[-openssl,-nss] )
			openssl? ( net-misc/curl[-gnutls,-nss] )
		)"

pkg_setup() {
	elog "This is a work-in-progress ebuild, some features will require"
	elog "manual configuration and others aren't fleshed out just yet."
	elog "Use it at your risk."

	if use gnutls && use openssl; then
		eerror "You cannot use both GnuTLS and OpenSSL at the same time"
		eerror "to provide the MD5 plugin. Please choose only one USE flag"
		eerror "between gnutls and openssl."
		die "Both gnutls and openssl USE flags enabled."
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2009.12.1240-nolint.patch"

	AT_M4DIR="m4" eautoreconf

	elibtoolize
}

src_configure() {
	local myconf=

	if use debug; then
		append-flags -DDEBUG
	fi

	if use gnutls; then
		myconf="${myconf} --with-md5-plugin"
		export ac_cv_libcrypto=no
	elif use openssl; then
		myconf="${myconf} --with-md5-plugin"
		export ac_cv_libgnutls_openssl=no
	else
		myconf="${myconf} --without-md5-plugin"
	fi

	econf \
		--disable-static \
		--disable-dependency-tracking \
		--disable-mtmalloc \
		$(use_enable tcmalloc) \
		$(use_enable memcache libmemcached) \
		$(use_enable gearman libgearman) \
		$(use_with curl auth-http-plugin) \
		$(use_with pam auth-pam-plugin) \
		--without-hello-world-plugin \
		${myconf}
}

src_compile() {
	emake || die "build failed"

	if use doc; then
		emake doxygen || die "doxygen failed"
	fi
}

src_test() {
	# Explicitly allow parallel make check
	emake check || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS README || die

	find "${D}" -name '*.la' -delete || die

	if use doc; then
		docinto apidoc
		pushd docs/html
		dohtml -r .
		popd
	fi
}

pkg_postinst() {
	if use pam; then
		ewarn "Be warned that we're still lacking a pam configuration"
		ewarn "file so the PAM authentication will not work by default"
	fi
}
