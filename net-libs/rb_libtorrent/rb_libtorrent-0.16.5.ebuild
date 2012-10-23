# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/rb_libtorrent/rb_libtorrent-0.16.5.ebuild,v 1.1 2012/10/23 22:02:10 hwoarang Exp $

EAPI="4"
PYTHON_DEPEND="python? 2:2.6"
PYTHON_USE_WITH="threads"
PYTHON_USE_WITH_OPT="python"

inherit multilib python versionator

MY_P=${P/rb_/}
MY_P=${MY_P/torrent/torrent-rasterbar}
S=${WORKDIR}/${MY_P}

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="http://www.rasterbar.com/products/libtorrent/"
SRC_URI="http://libtorrent.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc examples python ssl static-libs"
RESTRICT="test"

DEPEND=">=dev-libs/boost-1.48[python?]
	>=sys-devel/libtool-2.2
	sys-libs/zlib
	examples? ( !net-p2p/mldonkey )
	ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	use python && python_convert_shebangs -r 2 .
}

src_configure() {
	# use multi-threading versions of boost libs
	local BOOST_LIBS="--with-boost-system=boost_system-mt \
		--with-boost-python=boost_python-${PYTHON_ABI}-mt"
	# detect boost version and location, bug 295474
	BOOST_PKG="$(best_version ">=dev-libs/boost-1.34.1")"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	BOOST_VER="$(replace_all_version_separators _ "${BOOST_VER}")"
	BOOST_INC="${EPREFIX}/usr/include/boost-${BOOST_VER}"
	BOOST_LIB="${EPREFIX}/usr/$(get_libdir)/boost-${BOOST_VER}"

	local LOGGING
	use debug && LOGGING="--enable-logging=verbose"

	econf $(use_enable debug) \
		$(use_enable test tests) \
		$(use_enable examples) \
		$(use_enable python python-binding) \
		$(use_enable ssl encryption) \
		$(use_enable static-libs static) \
		${LOGGING} \
		--with-boost=${BOOST_INC} \
		--with-boost-libdir=${BOOST_LIB} \
		${BOOST_LIBS}
}

src_install() {
	emake DESTDIR="${D}" install
	use static-libs || find "${D}" -name '*.la' -exec rm -f {} +
	dodoc ChangeLog AUTHORS NEWS README
	if use doc; then
		dohtml docs/*
	fi
}
