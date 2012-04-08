# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ucommon/ucommon-5.2.2.ebuild,v 1.1 2012/04/08 18:30:38 maksbotan Exp $

EAPI="4"

inherit autotools-utils

DESCRIPTION="Portable C++ runtime for threads and sockets"
HOMEPAGE="http://www.gnu.org/software/commoncpp"
SRC_URI="mirror://gnu/commoncpp/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc static-libs socks +cxx debug ssl gnutls"

RDEPEND="ssl? ( dev-libs/openssl )"

DEPEND="dev-util/pkgconfig
	doc? ( app-doc/doxygen )
	${RDEPEND}"

DOCS=(README NEWS SUPPORT ChangeLog AUTHORS)
PATCHES=( "${FILESDIR}"/disable_rtf_gen_doxy.patch )

src_configure() {
	local myconf=""
	if ! use ssl && ! use gnutls; then
		myconf=" --with-sslstack=nossl "
	fi

	if use ssl; then
		myconf=" --with-sslstack=ssl "
	fi

	local myeconfargs=(
		$(use_enable  socks)
		$(use_enable  cxx stdcpp)
		${myconf}
		--enable-atomics
		--with-pkg-config
		--enable-posix-timers
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile doxy
}

src_install() {
	autotools-utils_src_install
	if use doc; then
		dohtml doc/html/*
	fi
}
