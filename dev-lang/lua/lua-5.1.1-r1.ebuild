# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/lua/lua-5.1.1-r1.ebuild,v 1.1 2007/01/13 14:28:52 mabi Exp $

inherit eutils portability

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="http://www.lua.org/"
SRC_URI="http://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~ppc ~ppc64 ~x86"
IUSE="readline static"

RDEPEND="readline? ( sys-libs/readline )
		dev-lang/lua-wrapper
		!=dev-lang/lua-5.1.1
		!=dev-lang/lua-5.0.3
		!=dev-lang/lua-5.0.2"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-Makefile.patch
	epatch "${FILESDIR}"/${P}-module_paths.patch

	sed -i -e 's:\(/README\)\("\):\1.gz\2:g' doc/readme.html

	if ! use readline ; then
		epatch "${FILESDIR}"/${P}-readline.patch
	fi

	# Using dynamic linked lua is not recommended upstream for performance
	# reasons. http://article.gmane.org/gmane.comp.lang.lua.general/18519
	# Mainly, this is of concern if your arch is poor with GPRs, like x86
	# Note that the lua compiler is build statically anyway
	if use static ; then
		epatch "${FILESDIR}"/${P}-make_static.patch
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
		liblibs="${liblibs} $(dlopen_lib)"
	fi

	# what to link to the executables
	mylibs=
	if use readline; then
		mylibs="-lreadline"
	fi

	cd src
	emake CFLAGS="${mycflags} ${CFLAGS}" \
			MYLDFLAGS="${LDFLAGS}" \
			RPATH="/usr/$(get_libdir)/" \
			LUA_LIBS="${mylibs}" \
			LIB_LIBS="${liblibs}" \
			V="${PV:0:3}" \
			gentoo_all || die "emake failed"

	mv lua_test ../test/lua.static
}

src_install() {
	emake INSTALL_TOP="${D}/usr/" V="${PV:0:3}" gentoo_install \
	|| die "emake install gentoo_install failed"

	dodoc HISTORY README
	dohtml doc/*.html doc/*.gif

	insinto /usr/share/pixmaps
	newins etc/lua.ico lua-5.1.ico
	insinto /usr/$(get_libdir)/pkgconfig
	newins etc/lua.pc lua-5.1.pc
}

src_test() {
	local positive="bisect cf echo env factorial fib fibfor hello printf sieve
	sort trace-calls trace-globals"
	local negative="readonly"
	local test

	cd "${S}"
	for test in ${positive}; do
		test/lua.static test/${test}.lua &> /dev/null || die "test $test failed"
	done

	for test in ${negative}; do
		test/lua.static test/${test}.lua &> /dev/null && die "test $test failed"
	done
}
