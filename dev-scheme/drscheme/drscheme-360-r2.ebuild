# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/drscheme/drscheme-360-r2.ebuild,v 1.3 2008/07/25 20:40:57 pchrist Exp $

inherit eutils multilib flag-o-matic libtool

DESCRIPTION="DrScheme programming environment.	Includes mzscheme."
HOMEPAGE="http://www.plt-scheme.org/software/drscheme/"
SRC_URI="http://download.plt-scheme.org/bundles/${PV}/plt/plt-${PV}-src-unix.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="3m backtrace cairo jpeg opengl perl png X"

RDEPEND="X? ( x11-libs/libICE
			  x11-libs/libSM
			  x11-libs/libXaw
			  >=x11-libs/libXft-2.1.12
			  media-libs/freetype
			  media-libs/fontconfig )
	cairo? ( >=x11-libs/cairo-1.2.3 )
	jpeg? ( media-libs/jpeg )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng )"

DEPEND="${RDEPEND}"

S="${WORKDIR}/plt-${PV}/src"

src_unpack() {
	unpack ${A}
	cd "${S}/.."

	epatch "${FILESDIR}/${PN}-350-fPIC.patch"
	epatch "${FILESDIR}/${P}-DESTDIR-3m.patch"

	cd "${S}/mzscheme/gc"
	elibtoolize
	cd "${S}"

	# lib dir fixups
	sed -ie 's:-rpath ${absprefix}/lib:-rpath ${absprefix}/'$(get_libdir)':g' configure
}

src_compile() {
	# -O3 seems to cause some miscompiles, this should fix #141925 and #133888
	replace-flags -O? -O2

	econf $(use_enable X mred) \
		--enable-shared \
		--enable-lt=/usr/bin/libtool \
		$(use_enable backtrace) \
		$(use_enable cairo) \
		$(use_enable jpeg libjpeg) \
		$(use_enable opengl gl) \
		$(use_enable perl) \
		$(use_enable png libpng) \
		|| die "econf failed"

	emake || die "emake failed"

	if use 3m; then
		emake -j1 3m || die "emake 3m failed"
	fi
}

src_install() {
	export MZSCHEME_DYNEXT_LINKER_FLAGS=$(raw-ldflags)

	make DESTDIR="${D}" install || die "make install failed"

	if use 3m; then
		make DESTDIR="${D}" install-3m || die "make install-m3 failed"
	fi

	dodoc "${WORKDIR}/plt/{readme.txt,src/README}"

	mv -f "${D}"/usr/share/plt/doc/* "${D}/usr/share/doc/${PF}/"
	rm -rf "${D}/usr/share/plt/doc"

	# needed so online help works
	keepdir /usr/share/plt
	dosym "/usr/share/doc/${PF}" "/usr/share/plt/doc"

	if use X; then
		newicon "${WORKDIR}/plt-${PV}/collects/icons/PLT-206.png" drscheme.png
		make_desktop_entry drscheme "DrScheme" drscheme "Development"
	fi
}
