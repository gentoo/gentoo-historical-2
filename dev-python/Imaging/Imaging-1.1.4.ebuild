# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/Imaging/Imaging-1.1.4.ebuild,v 1.12 2004/04/26 01:22:11 agriffis Exp $

inherit distutils eutils

DESCRIPTION="Python Imaging Library (PIL)"
HOMEPAGE="http://www.pythonware.com/products/pil/index.htm"
SRC_URI="http://www.effbot.org/downloads/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ~ppc sparc ~alpha ~amd64"
IUSE="tcltk"

DEPEND="virtual/python
	>=media-libs/jpeg-6a
	>=sys-libs/zlib-0.95
	tcltk? ( dev-lang/tk )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-setup.py.patch
	epatch ${FILESDIR}/${P}-fPIC.patch
}

src_compile() {
	export OPT=${CFLAGS}

	#Build the core imaging library (libImaging.a)
	cd ${S}/libImaging
	econf || die "econf failed"
	#Not configured by configure
	sed -e "s:\(JPEGINCLUDE=[[:blank:]]*/usr/\)local/\(include\).*:\1\2:" \
		-i Makefile
	emake || die
	cd ${S}; distutils_src_compile
}

src_install() {
	local mydoc="CHANGES* CONTENTS"
	distutils_src_install
	distutils_python_version

	# install headers required by media-gfx/sketch
	insinto "${ROOT}/usr/include/python${PYVER}"
	doins libImaging/Imaging.h
	doins libImaging/ImPlatform.h
	doins libImaging/ImConfig.h
}
