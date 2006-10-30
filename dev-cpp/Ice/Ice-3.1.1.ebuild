# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/Ice/Ice-3.1.1.ebuild,v 1.1 2006/10/30 13:31:47 caleb Exp $

inherit eutils

DESCRIPTION="ICE middleware C++ bindings"
HOMEPAGE="http://www.zeroc.com/index.html"
SRC_URI="http://www.zeroc.com/download/Ice/3.1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ncurses test debug"

DEPEND="ncurses? ( sys-libs/ncurses sys-libs/readline )
	test? ( >=dev-lang/python-2.2 )
	~sys-libs/db-4.3.29
	>=dev-libs/openssl-0.9.7"
RDEPEND=">=dev-libs/expat-1.9
	>=app-arch/bzip2-1.0"

pkg_setup() {
	built_with_use sys-libs/db nocxx && die "DB must be compiled with C++ support!"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-Makefile.patch
	epatch "${FILESDIR}"/ice-makefile-speedup.patch

	if use amd64; then
		sed -i -e "s:^#LP64:LP64:g" ${S}/config/Make.rules \
		|| die "Failed to set lib64 directory"
	fi

	if ! use ncurses; then
		sed -i -e "s#   USE_READLINE.*#   USE_READLINE := no#g" \
		${S}/config/Make.rules || die "Failed to set no readline"
	fi

	if ! use debug; then
		sed -i -e "s:#OPTIMIZE:OPTIMIZE:" \
		${S}/config/Make.rules || die "Failed to remove debug"
	fi

	sed -i -e \
	"s:.*CXXFLAGS[^\+]*\=\s:CXXFLAGS = ${CXXFLAGS} :g" \
	${S}/config/Make.rules.Linux || die "CXXFLAGS patching failed!"
}

src_install() {
	make DESTDIR="${D}" install || die "Install Failed!"
}

src_test() {
	make test || die "Test failed"
}
