# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/lcdf-typetools/lcdf-typetools-2.69.ebuild,v 1.5 2008/08/12 11:47:35 armin76 Exp $

DESCRIPTION="Font utilities for eg manipulating OTF"
SRC_URI="http://www.lcdf.org/type/${P}.tar.gz"
HOMEPAGE="http://www.lcdf.org/type/#typetools"
KEYWORDS="alpha amd64 ~hppa ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
SLOT="0"
LICENSE="GPL-2"
IUSE="kpathsea"

DEPEND="kpathsea? ( virtual/tex-base )"

src_compile() {
	econf $(use_with kpathsea) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README ONEWS
}
