# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/highlight/highlight-2.6.10.ebuild,v 1.1 2008/05/23 14:12:21 drac Exp $

WX_GTK_VER=2.6

inherit wxwidgets eutils toolchain-funcs

DESCRIPTION="converts source code to formatted text ((X)HTML, RTF, (La)TeX, XSL-FO, XML) with syntax highlight"
HOMEPAGE="http://www.andre-simon.de"
SRC_URI="http://www.andre-simon.de/zip/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="wxwindows"

DEPEND="wxwindows? ( =x11-libs/wxGTK-2.6* )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-2.6.9-gcc43.patch \
		"${FILESDIR}"/${PN}-2.6.9-asneeded.patch \
		"${FILESDIR}"/${P}-conf_dir.patch
	sed -i \
		-e "s:-O2::" \
		-e "s:CFLAGS:CXXFLAGS:g" \
		src/makefile || die "sed failed."
}

src_compile() {
	emake -f makefile CXX="$(tc-getCXX)" all || die "emake all failed."
	if use wxwindows; then
		need-wxwidgets ansi
		emake -f makefile CXX="$(tc-getCXX)" all-gui || die "emake all-gui failed."
	fi
}

src_install() {
	dodir /usr/bin
	emake -f makefile \
		DESTDIR="${D}" \
		install || die "emake install failed."
	if use wxwindows; then
		emake -f makefile \
			DESTDIR="${D}" \
			install-gui || die "emake install-gui failed."
	fi
}
