# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/museek+/museek+-0.1.13-r1.ebuild,v 1.1 2007/09/23 12:20:22 coldwind Exp $

inherit qt3 eutils distutils multilib

DESCRIPTION="A SoulSeek client which uses a daemon and multiple gui clients."
HOMEPAGE="http://www.museek-plus.org"
SRC_URI="mirror://sourceforge/museek-plus/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug fam gtk ncurses qsa qt3 trayicon vorbis"

RDEPEND=">=dev-cpp/libxmlpp-1.0.2
	gtk? ( >=dev-python/pygtk-2.6.1 )
	qt3? ( $(qt_min_version 3.3) )
	qsa? ( >=dev-libs/qsa-1.1.1 )
	vorbis? ( media-libs/libvorbis
		media-libs/libogg )
	fam? ( virtual/fam )"
DEPEND="${RDEPEND}
		dev-lang/swig"

pkg_setup() {
	if use ncurses && ! built_with_use dev-lang/python ncurses ; then
		eerror "In order to build Mucous (museek ncurses client)"
		eerror "you need dev-lang/python built with ncurses USE flag enabled."
		die "no ncurses support in Python"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-optional-deps.patch"
	epatch "${FILESDIR}/${P}-post_release_fixes.patch"
	sed -i -e "s:join('lib':join('$(get_libdir)':g" \
		*/CMakeLists.txt || die "sed failed"
}

my_use() {
	use $1 && echo "1" || echo "0"
}

my_not_use() {
	use $1 && echo "0" || echo "1"
}

src_compile() {
	# Build museekd, mucous, murmur, python bindings and clients
	local myconf="-DPREFIX=/usr -DMANDIR=share/man -DBINDINGS=1 -DCLIENTS=1"
	myconf="${myconf} -DSWIG_DIR='$(swig -swiglib)'" # bug #192594
	myconf="${myconf} -DMUCOUS=$(my_use ncurses)
		-DMURMUR=$(my_use gtk)
		-DNO_MUSEEQ=$(my_not_use qt3)
		-DTRAYICON=$(my_use trayicon)
		-DQSA=$(my_use qsa)
		-DNO_MUSCAND=$(my_not_use fam)
		-DVORBIS=$(my_use vorbis)"
	if ! use debug ; then
		myconf="${myconf} -DMULOG=none"
	fi

	cmake ${myconf} || die "cmake failed"
	emake || die "emake failed"

	# Build setup tools
	cd "${S}/setup"
	distutils_src_compile
}

src_install() {
	# Install main stuff
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README CREDITS CHANGELOG TODO

	# Install setup tools
	cd "${S}/setup"
	distutils_src_install
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "In order to configure ${PN} execute musetup, musetup-gtk,"
	elog "or musetup-qt with your user."
	elog "Then you can launch ${PN} daemon with 'museekd' and use"
	elog "any of the provided clients."
}
