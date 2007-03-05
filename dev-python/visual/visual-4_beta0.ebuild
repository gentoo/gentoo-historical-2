# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/visual/visual-4_beta0.ebuild,v 1.3 2007/03/05 03:10:14 genone Exp $

inherit distutils versionator multilib

MY_P=$(replace_version_separator _ . ${P})

S="${WORKDIR}/${MY_P}"

DESCRIPTION="An easy to use Real-time 3D graphics library for Python."
SRC_URI="http://www.vpython.org/download/${MY_P}.tar.bz2"
HOMEPAGE="http://www.vpython.org/"

IUSE="doc examples numeric numarray"
SLOT="0"
KEYWORDS="~x86"
LICENSE="visual"

DEPEND=">=dev-lang/python-2.2
		>=dev-libs/boost-1.31
		virtual/opengl
		=dev-cpp/gtkglextmm-1.2*
		dev-cpp/libglademm
		numeric? ( dev-python/numeric )
		numarray? ( >=dev-python/numarray-1.0 )
		!numeric? ( !numarray? ( dev-python/numeric ) )"

RDEPEND=${DEPEND}

src_compile() {
	local myconf="--without-numarray --without-numeric"

	echo
	if useq numeric; then
		elog "Building with Numeric support"
		myconf=${myconf/--without-numeric}
	fi
	if useq numarray; then
		elog "Building with Numarray support"
		myconf=${myconf/--without-numarray}
	fi
	if ! useq numeric && ! useq numarray; then
		elog "Support for Numeric or Numarray was not specified."
		elog "Building with Numeric support"
		myconf=${myconf/--without-numeric}
	fi
	echo

	econf \
	--with-html-dir=/usr/share/doc/${PF}/html \
	--with-example-dir=/usr/share/doc/${PF}/examples \
	$(use_enable doc docs ) \
	$(use_enable examples ) \
	${myconf} \
	|| die "configure failed"

	sed -i s/boost_thread/boost_thread-mt/ src/Makefile

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"

	python_version

	mv ${D}/usr/$(get_libdir)/python${PYVER}/site-packages/cvisualmodule* \
		${D}/usr/$(get_libdir)/python${PYVER}/site-packages/visual

	#the vpython script does not work, and is unnecessary
	rm ${D}/usr/bin/vpython
}
