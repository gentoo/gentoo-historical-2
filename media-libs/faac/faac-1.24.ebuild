# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/faac/faac-1.24.ebuild,v 1.19 2005/09/09 11:15:52 flameeyes Exp $

inherit libtool eutils

DESCRIPTION="Free MPEG-4 audio codecs by AudioCoding.com"
HOMEPAGE="http://www.audiocoding.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc-macos ppc64 sparc x86"
IUSE=""

RDEPEND=">=media-libs/libsndfile-1.0.0"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-1.3.5
	sys-devel/automake
	!<media-libs/faad2-2.0-r3"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}

	cd ${S}

	export WANT_AUTOMAKE=1.7
	export WANT_AUTOCONF=2.5
	sh ./bootstrap
	elibtoolize
	epunt_cxx
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO docs/libfaac.pdf
}
