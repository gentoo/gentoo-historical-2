# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/lua/lua-5.1.1.ebuild,v 1.2 2006/11/18 10:55:05 opfer Exp $

inherit eutils portability

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="http://www.lua.org/"
SRC_URI="http://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="readline"

RDEPEND="readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-make.patch
	epatch "${FILESDIR}"/${P}-module_paths.patch

	sed -i -e 's:\(/README\)\("\):\1.gz\2:g' doc/readme.html

	if ! use readline ; then
		epatch "${FILESDIR}"/${P}-readline.patch
	fi
}

src_compile() {
	myflags=
	# what to link to liblua
	liblibs="-lm"
	if use ppc-macos; then
		mycflags="${mycflags} -DLUA_USE_MACOSX"
	else # building for standard linux (and bsd too)
		mycflags="${mycflags} -DLUA_USE_LINUX"
		liblibs="${liblibs} -ldl"
	fi

	# what to link to the executables
	mylibs=
	if use readline; then
		mylibs="-lreadline"
	fi

	cd src
	emake CFLAGS="${mycflags} ${CFLAGS}" \
			RPATH="/usr/$(get_libdir)/" \
			LUA_LIBS="${mylibs}" \
			LIB_LIBS="${liblibs}" \
			V=${PV} \
			gentoo_all || die "emake failed"
}

src_install() {
	emake INSTALL_TOP="${D}/usr/" V=${PV} gentoo_install \
	|| die "emake install gentoo_install failed"

	dodoc HISTORY README
	dohtml doc/*.html doc/*.gif

	insinto /usr/share/pixmaps
	doins etc/lua.ico
	insinto /usr/$(get_libdir)/pkgconfig
	doins etc/lua.pc
}

src_test() {
	local positive="bisect cf echo env factorial fib fibfor hello printf sieve
	sort trace-calls trace-globals"
	local negative="readonly"
	local test

	cd "${S}"
	for test in ${positive}; do
		src/${P} test/${test}.lua &> /dev/null || die "test $test failed"
	done

	for test in ${negative}; do
		src/${P} test/${test}.lua &> /dev/null && die "test $test failed"
	done
}
