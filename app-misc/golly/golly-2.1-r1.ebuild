# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/golly/golly-2.1-r1.ebuild,v 1.2 2010/10/28 15:31:24 hwoarang Exp $

EAPI=2
PYTHON_DEPEND=2
WX_GTK_VER=2.8

inherit eutils python wxwidgets toolchain-funcs

MY_P=${P}-src
DESCRIPTION="A simulator for Conway's Game of Life and other cellular automata"
HOMEPAGE="http://golly.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl[ithreads]
	|| ( <=x11-libs/wxGTK-2.8.10.1-r5:2.8[X] >=x11-libs/wxGTK-2.8.11.0:2.8[X,tiff] )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	# Fix linker flags to work with Perl 5.10.1 (fixed in CVS)
	epatch "${FILESDIR}"/${P}-perl-ldopts.patch

	# Fix Python symbol names on AMD64 (fixed in CVS)
	epatch "${FILESDIR}"/${P}-python-amd64.patch

	# Fix installing data files into a different directory than binaries:
	epatch "${FILESDIR}"/${PN}-separate-data-directory.patch

	# We need this for correct linking
	epatch "${FILESDIR}"/${P}-as-needed.patch

	# Get rid of .DS_Store and other stuff that should not be installed:
	find -type f -name '.*' -exec rm -f {} + || die
	find Scripts/Python -name '*.pyc' -exec rm -f {} + || die

	# Fix Python library path:
	sed -i -e "s|libpython2.5.so|$(python_get_library)|" wxprefs.cpp || die

	# Insert user-specified compiler flags into Makefile:
	sed -i -e "/^CXXFLAGS = /s/-O5/${CXXFLAGS}/" makefile-gtk || die
}

src_compile() {
	emake \
		CXXC="$(tc-getCXX)" \
		-f makefile-gtk || die
}

src_install() {
	dobin golly bgolly RuleTableToTree || die

	insinto /usr/share/${PN}
	doins -r Help Patterns Scripts Rules || die

	dodoc README || die
}
