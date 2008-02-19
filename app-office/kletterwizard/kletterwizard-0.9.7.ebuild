# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kletterwizard/kletterwizard-0.9.7.ebuild,v 1.7 2008/02/19 02:29:18 ingmar Exp $

inherit kde

DESCRIPTION="KLetterWizard is a KDE application which simplifies letter writing and produces output via LaTeX."
HOMEPAGE="http://www.kluenter.de/klw.html"
SRC_URI="http://www.kluenter.de/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="kdeenablefinal"

DEPEND="virtual/tetex
	|| ( =kde-base/kghostview-3.5* =kde-base/kdegraphics-3.5* )"
RDEPEND="${DEPEND}"

need-kde 3.4

src_unpack() {
	kde_src_unpack
	epatch "${FILESDIR}/${PN}-0.9.6-gentoo.diff"
	epatch "${FILESDIR}/${P}-gcc-4.1.patch"
}

src_compile() {
	myconf="--with-texmf-path=/usr/share/texmf"
	kde_src_compile
}

pkg_postinst() {
	einfo "Running texhash to complete install..."
	addwrite "/var/lib/texmf"
	addwrite "/usr/share/texmf"
	addwrite "/var/cache/fonts"
	texhash
}
