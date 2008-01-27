# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gigedit/gigedit-0.1.1.ebuild,v 1.1 2008/01/27 10:15:26 aballier Exp $

DESCRIPTION="An instrument editor for gig files"
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=media-sound/linuxsampler-0.5
	>=dev-cpp/gtkmm-2.4.10
	>=media-libs/libgig-3.2.0
	>=media-libs/libsndfile-1.0.2"

RDEPEND="${DEPEND}"

src_compile() {
	econf
	emake -j1 || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
