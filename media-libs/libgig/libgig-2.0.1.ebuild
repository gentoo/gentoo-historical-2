# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libgig/libgig-2.0.1.ebuild,v 1.4 2006/03/06 15:11:02 flameeyes Exp $

inherit eutils

DESCRIPTION="libgig is a C++ library for loading Gigasampler files and DLS (Downloadable Sounds) Level 1/2 files."
HOMEPAGE="http://stud.fh-heilbronn.de/~cschoene/projects/libgig/"
SRC_URI="http://stud.fh-heilbronn.de/~cschoene/projects/libgig/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"
RDEPEND=">=media-libs/libsndfile-1.0.2
	>=media-libs/audiofile-0.2.3"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_compile() {
	econf || die "./configure failed"
	emake -j1 || die "make failed"

	if use doc; then
		make docs || die "make docs failed"
	fi
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog TODO README

	if use doc; then
		mv ${S}/doc/html ${D}/usr/share/doc/${PF}/
	fi
}
