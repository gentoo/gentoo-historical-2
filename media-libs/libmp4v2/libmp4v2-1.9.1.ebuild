# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmp4v2/libmp4v2-1.9.1.ebuild,v 1.5 2009/08/15 08:39:40 maekke Exp $

EAPI=2
inherit libtool

DESCRIPTION="Functions for accessing ISO-IEC:14496-1:2001 MPEG-4 standard"
HOMEPAGE="http://code.google.com/p/mp4v2"
SRC_URI="http://mp4v2.googlecode.com/files/${P/lib}.tar.bz2"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE="utils"

RDEPEND=""
DEPEND="utils? ( sys-apps/help2man )
	!media-video/mpeg4ip
	sys-apps/sed"

RESTRICT="test"

S=${WORKDIR}/${P/lib}

src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		--disable-gch \
		$(use_enable utils util) \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc doc/*.txt README
}
