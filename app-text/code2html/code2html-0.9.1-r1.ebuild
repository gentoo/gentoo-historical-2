# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/code2html/code2html-0.9.1-r1.ebuild,v 1.2 2007/07/12 04:37:47 mr_bones_ Exp $

inherit eutils

DESCRIPTION="Converts source files to colored HTML output."
HOMEPAGE="http://www.palfrader.org/code2html/"
SRC_URI="http://www.palfrader.org/code2html/all/${P}.tar.gz
	mirror://gentoo/${P}-gentoo_patches.tar.bz2"

LICENSE="as-is"
SLOT="0"

KEYWORDS="~amd64 ~hppa ~ppc ~ppc-macos ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/perl-5"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Be consistent in color codes (bug #119406)
	epatch "${WORKDIR}"/${P}-lowercase_color_codes.patch

	# Improved C++ support (bug #133159)
	epatch "${WORKDIR}"/${P}-cpp_keywords.patch

	# Improved Ada support (bug #133176)
	epatch "${WORKDIR}"/${P}-ada_identifiers.patch
}

src_install () {
	into /usr
	dobin code2html
	dodoc ChangeLog CREDITS LICENSE README
	doman code2html.1
}
