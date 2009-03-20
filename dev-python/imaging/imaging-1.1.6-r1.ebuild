# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/imaging/imaging-1.1.6-r1.ebuild,v 1.1 2009/03/20 18:52:16 bicatali Exp $

EAPI=2
inherit eutils distutils

MY_P=Imaging-${PV}

DESCRIPTION="Python Imaging Library (PIL)"
HOMEPAGE="http://www.pythonware.com/products/pil/index.htm"
SRC_URI="http://www.effbot.org/downloads/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc examples scanner tk X"

DEPEND="media-libs/jpeg
	media-libs/freetype:2
	tk? ( dev-lang/python[tk?] )
	scanner? ( media-gfx/sane-backends )
	X? ( x11-misc/xdg-utils )"
RDEPEND="${DEPEND}"

PYTHON_MODNAME=PIL
S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-xv.patch
	epatch "${FILESDIR}"/${P}-sane.patch
	epatch "${FILESDIR}"/${P}-giftrans.patch
	epatch "${FILESDIR}"/${P}-tiffendian.patch
	sed -i \
		-e "s:/usr/lib\":/usr/$(get_libdir)\":" \
		-e "s:\"lib\":\"$(get_libdir)\":g" \
		setup.py || die "sed failed"
	if ! use tk ; then
		# Make the test always fail
		sed -i \
			-e 's/import _tkinter/raise ImportError/' \
			setup.py || die "sed failed"
	fi
}

src_compile() {
	distutils_src_compile
	if use scanner ; then
		cd "${S}/Sane"
		distutils_src_compile
	fi
}

src_test() {
	"${python}" selftest.py || die
}

src_install() {
	local DOCS="CHANGES CONTENTS"
	distutils_src_install

	use doc && dohtml Docs/*

	if use scanner ; then
		cd "${S}/Sane"
		docinto sane
		local DOCS="CHANGES sanedoc.txt"
		distutils_src_install
		cd "${S}"
	fi

	# install headers required by media-gfx/sketch
	distutils_python_version
	insinto /usr/include/python${PYVER}
	doins libImaging/Imaging.h
	doins libImaging/ImPlatform.h

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins Scripts/*
		if use scanner ; then
			insinto /usr/share/doc/${PF}/examples/sane
			doins Sane/demo_*.py
		fi
	fi
}
