# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/tinyxml/tinyxml-2.6.2-r1.ebuild,v 1.2 2011/11/13 14:52:43 maekke Exp $

EAPI=4
inherit flag-o-matic toolchain-funcs eutils multilib

DESCRIPTION="a simple, small, C++ XML parser that can be easily integrating into other programs"
HOMEPAGE="http://www.grinninglizard.com/tinyxml/index.html"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV//./_}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc x86 ~x64-macos ~x86-macos"
IUSE="debug doc static-libs +stl"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}"

src_prepare() {
	local major_v minor_v
	major_v=$(echo ${PV} | cut -d \. -f 1)
	minor_v=$(echo ${PV} | cut -d \. -f 2-3)

	sed -e "s:@MAJOR_V@:$major_v:" \
	    -e "s:@MINOR_V@:$minor_v:" \
		"${FILESDIR}"/Makefile-3 > Makefile || die

	epatch "${FILESDIR}"/${PN}-2.6.1-entity.patch

	use debug && append-cppflags -DDEBUG
	use stl && append-cppflags -DTIXML_USE_STL

	tc-export AR CXX RANLIB

	[[ ${CHOST} == *-darwin* ]] && export LIBDIR="${EPREFIX}"/usr/$(get_libdir)
}

src_install() {
	dolib.so *$(get_libname)*
	use static-libs && dolib.a *.a

	insinto /usr/include
	doins *.h

	dodoc {changes,readme}.txt

	if use doc; then
		dohtml -r docs/*
	fi
}
