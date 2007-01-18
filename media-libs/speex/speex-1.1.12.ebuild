# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/speex/speex-1.1.12.ebuild,v 1.4 2007/01/18 08:02:20 opfer Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils autotools libtool

DESCRIPTION="Speech encoding library"
HOMEPAGE="http://www.speex.org/"
SRC_URI="http://downloads.xiph.org/releases/speex/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE="ogg sse vorbis-psy"

RDEPEND="ogg? ( >=media-libs/libogg-1.0 )"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	# This is needed to fix parallel make issues.
	# As this changes the Makefile.am, need to rebuild autotools.
	sed -i -e 's:\$(top_builddir)/libspeex/libspeex.la:libspeex.la:' \
		${S}/libspeex/Makefile.am

	epatch "${FILESDIR}/${P}-malloc.patch"

	eautoreconf

	# Better being safe
	elibtoolize
}

src_compile() {
	# ogg autodetect only
	econf \
		$(use_enable vorbis-psy) \
		$(use_enable sse) \
		|| die
	emake || die
}

src_install () {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog README* TODO NEWS
}
