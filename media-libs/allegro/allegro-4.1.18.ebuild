# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/allegro/allegro-4.1.18.ebuild,v 1.6 2006/03/31 21:15:34 tupone Exp $

inherit flag-o-matic eutils

DESCRIPTION="cross-platform multimedia library"
HOMEPAGE="http://alleg.sourceforge.net/"
SRC_URI="mirror://sourceforge/alleg/${P}.tar.gz"

LICENSE="Allegro"
SLOT="0"
#-amd64, -sparc: inportb, outportb, outportw undefined
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc -sparc ~x86"
IUSE="static mmx sse oss alsa esd arts X fbcon svga tetex doc"

RDEPEND="alsa? ( media-libs/alsa-lib )
	esd? ( media-sound/esound )
	arts? ( kde-base/arts )
	X? (
		|| (
			(
				x11-libs/libXxf86vm
				x11-libs/libXxf86dga
			)
			virtual/x11
		)
	)
	svga? ( media-libs/svgalib )"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	X? (
		|| (
			(
				x11-proto/xextproto
				x11-proto/xf86dgaproto
				x11-proto/xf86vidmodeproto
			)
			virtual/x11
		)
	)
	tetex? ( virtual/tetex )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-m4.patch
	epatch "${FILESDIR}"/${P}-gcc4.patch
	sed -i \
		-e 's/&_oss_\(numfrags\|fragsize\)/NULL/' \
		"${S}/setup/setup.c" \
		|| die "sed failed"
}

src_compile() {
	filter-flags -fPIC -fprefetch-loop-arrays
	econf \
		--enable-linux \
		--enable-vga \
		$(use_enable static) \
		$(use_enable static staticprog) \
		$(use_enable mmx) \
		$(use_enable sse) \
		$(use_enable oss ossdigi) \
		$(use_enable oss ossmidi) \
		$(use_enable alsa alsadigi) \
		$(use_enable alsa alsamidi) \
		$(use_enable esd esddigi) \
		$(use_enable arts artsdigi) \
		$(use_with X x) \
		$(use_enable X xwin-shm) \
		$(use_enable X xwin-vidmode) \
		$(use_enable X xwin-dga) \
		$(use_enable X xwin-dga2) \
		$(use_enable fbcon) \
		$(use_enable svga svgalib) \
		|| die

	emake -j1 CFLAGS="${CFLAGS}" || die "emake failed"

	if use tetex ; then
		addwrite /var/lib/texmf
		addwrite /usr/share/texmf
		addwrite /var/cache/fonts
		make docs-dvi docs-ps || die
	fi
}

src_install() {
	addpredict /usr/share/info
	make DESTDIR="${D}" \
		install \
		install-gzipped-man \
		install-gzipped-info \
		|| die "make install failed"

	# Different format versions of the Allegro documentation
	dodoc AUTHORS CHANGES THANKS readme.txt todo.txt
	use tetex && dodoc docs/allegro.{dvi,ps}
	use doc && dodoc examples/*
	dohtml docs/html/*
	docinto txt
	dodoc docs/txt/*.txt
	docinto rtf
	dodoc docs/rtf/*.rtf
	docinto build
	dodoc docs/build/*.txt
}
