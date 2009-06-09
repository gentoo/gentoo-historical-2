# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libtheora/libtheora-1.1_alpha2.ebuild,v 1.1 2009/06/09 16:55:43 ssuominen Exp $

EAPI=2
inherit autotools eutils flag-o-matic

DESCRIPTION="The Theora Video Compression Codec"
HOMEPAGE="http://www.theora.org"
SRC_URI="http://downloads.xiph.org/releases/theora/${P/_}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc encode examples"

RDEPEND="media-libs/libogg
	encode? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	dev-util/pkgconfig"

VARTEXFONTS=${T}/fonts
S=${WORKDIR}/${P/_}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0_beta2-flags.patch
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	use x86 && filter-flags -fforce-addr -frename-registers #200549
	use doc || export ac_cv_prog_HAVE_DOXYGEN="false"

	# Don't build specs even with doc enabled, just a few people would need
	# it and causes sandbox violations.
	export ac_cv_prog_HAVE_PDFLATEX="false"

	econf \
		--disable-dependency-tracking \
		--disable-sdltest \
		$(use_enable encode) \
		--disable-examples
}

src_install() {
	emake DESTDIR="${D}" docdir=/usr/share/doc/${PF} \
		install || die "emake install failed"
	dodoc AUTHORS CHANGES README
	prepalldocs

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.[ch]
	fi
}
