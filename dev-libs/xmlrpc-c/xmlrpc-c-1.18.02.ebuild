# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xmlrpc-c/xmlrpc-c-1.18.02.ebuild,v 1.2 2009/04/29 09:08:40 loki_val Exp $

EAPI=2

inherit eutils multilib base autotools

DESCRIPTION="A lightweigt RPC library based on XML and HTTP"
SRC_URI="mirror://gentoo/${PN}/${P}.tar.bz2"
HOMEPAGE="http://xmlrpc-c.sourceforge.net/"

KEYWORDS=" ~amd64 ~arm ~ia64 ~mips ~ppc ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="+curl +cxx tools +cgi abyss threads"
LICENSE="BSD"
SLOT="0"

DEPEND="dev-libs/libxml2
	tools? ( dev-perl/frontier-rpc )
	curl? ( net-misc/curl )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! use curl
	then
		ewarn "Curl support disabled: No client library will be be built"
	fi
}

#Bug 214137: We need to filter this.
unset SRCDIR

PATCHES=( "${FILESDIR}/${P}/dumpvalue.patch" )

src_prepare() {
	base_src_util autopatch

	# Respect the user's CFLAGS/CXXFLAGS.
	sed -i \
		-e "/CFLAGS_COMMON/s:-g -O3$:${CFLAGS}:" \
		-e "/CXXFLAGS_COMMON/s:-g$:${CXXFLAGS}:" \
		"${S}"/common.mk || die "404. File not found while sedding"

	sed -i \
		-e "/^LIBINST_DIR = / s:\$(PREFIX)/lib:\$(PREFIX)/$(get_libdir):" \
		config.mk.in
	eautoconf
}

src_configure() {
	# Respect the user's LDFLAGS.
	export LADD=${LDFLAGS}
	econf	--disable-wininet-client \
		--disable-libwww-client \
		--enable-libxml2-backend \
		$(use_enable tools) \
		$(use_enable threads abyss-threads) \
		$(use_enable cgi cgi-server) \
		$(use_enable abyss abyss-server) \
		$(use_enable cxx cplusplus) \
		$(use_enable curl curl-client) \
		|| die "econf failed"
}

src_compile() {
	emake || die "Compiling failed"
}

src_test() {
	if use abyss
	then
		unset LDFLAGS LADD SRCDIR
		cd "${S}"/src/test/
		einfo "Building general tests"
		make || die "Make of general tests failed"
		einfo "Running general tests"
		./test || die "General tests failed"

		if use cpp
		then
			cd "${S}"/src/cpp/test
			einfo "Building C++ tests"
			make || die "Make of C++ tests failed"
			einfo "Running C++ tests"
			./test || die "C++ tests failed"
		fi
	else
		elog "Running of tests in ${PN} fails unless USE='abyss' is set."
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
}
