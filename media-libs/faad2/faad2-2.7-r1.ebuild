# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/faad2/faad2-2.7-r1.ebuild,v 1.3 2009/07/20 17:30:18 ssuominen Exp $

EAPI=2
inherit autotools eutils

DESCRIPTION="AAC audio decoding library"
HOMEPAGE="http://www.audiocoding.com/faad2.html"
SRC_URI="mirror://sourceforge/faac/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="digitalradio"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libmp4ff-shared-lib.patch \
		"${FILESDIR}"/${P}-man1_MANS.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_with digitalradio drm) \
		--without-xmms
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README README.linux TODO
}
