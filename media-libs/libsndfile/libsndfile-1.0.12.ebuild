# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsndfile/libsndfile-1.0.12.ebuild,v 1.2 2005/10/30 15:49:30 flameeyes Exp $

inherit eutils

DESCRIPTION="A C library for reading and writing files containing sampled sound"
HOMEPAGE="http://www.mega-nerd.com/libsndfile/"
SRC_URI="http://www.mega-nerd.com/libsndfile/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE="static sqlite"

RDEPEND="media-libs/flac
	sqlite? ( >=dev-db/sqlite-3.2 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epunt_cxx
	elibtoolize
}

src_compile() {
	econf \
		$(use_enable sqlite) \
		$(use_enable static) \
		--disable-dependency-tracking

	# fix this weird doc installation directory libsndfile decides
	# to something more standard
	sed -e "s:^htmldocdir.*:htmldocdir = /usr/share/doc/${PF}/html:" -i ${S}/doc/Makefile

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed"
}

src_test() { :; }
