# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ghostscript-gnu/ghostscript-gnu-8.60.ebuild,v 1.1 2007/10/21 18:12:49 genstef Exp $

WANT_AUTOMAKE=1.9

inherit autotools elisp-common eutils versionator flag-o-matic

DESCRIPTION="GNU Ghostscript - patched GPL Ghostscript"
HOMEPAGE="http://www.gnu.org/software/ghostscript/"

MY_P=gnu-ghostscript-${PV}
PVM=$(get_version_component_range 1-2)
SRC_URI="cjk? ( ftp://ftp.gyve.org/pub/gs-cjk/adobe-cmaps-200406.tar.gz
		ftp://ftp.gyve.org/pub/gs-cjk/acro5-cmaps-2001.tar.gz )
	mirror://gnu/ghostscript/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="X cups cjk gtk jpeg2k"

DEP="virtual/libc
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.2.5
	>=sys-libs/zlib-1.1.4
	>=media-libs/tiff-3.7
	X? ( x11-libs/libXt x11-libs/libXext )
	gtk? ( >=x11-libs/gtk+-2.0 )
	cups? ( >=net-print/cups-1.1.20 )
	jpeg2k? ( media-libs/jasper )
	!app-text/ghostscript-esp
	!app-text/ghostscript-gpl"

RDEPEND="${DEP}
	cjk? ( media-fonts/arphicfonts
		media-fonts/kochi-substitute
		media-fonts/baekmuk-fonts )
	media-fonts/gnu-gs-fonts-std"

DEPEND="${DEP}
	gtk? ( dev-util/pkgconfig )"

S=${WORKDIR}/${MY_P}


src_unpack() {
	unpack ${A/adobe-cmaps-200406.tar.gz acro5-cmaps-2001.tar.gz}
	if use cjk; then
		cat "${FILESDIR}"/ghostscript-esp-8.15.2-cidfmap.cjk >> "${S}"/lib/cidfmap
		cat "${FILESDIR}"/ghostscript-esp-8.15.2-FAPIcidfmap.cjk >> "${S}"/lib/FAPIcidfmap
		cd "${S}"/Resource
		unpack adobe-cmaps-200406.tar.gz
		unpack acro5-cmaps-2001.tar.gz
		cd ${WORKDIR}
	fi

	cd ${S}

	# search path fix
	sed -i -e "s:\$\(gsdatadir\)/lib:/usr/share/ghostscript/${PVM}/$(get_libdir):" \
		-e 's:$(gsdir)/fonts:/usr/share/fonts/default/ghostscript/:' \
		-e "s:exdir=.*:exdir=/usr/share/doc/${PF}/examples:" \
		-e "s:docdir=.*:docdir=/usr/share/doc/${PF}/html:" \
		-e "s:GS_DOCDIR=.*:GS_DOCDIR=/usr/share/doc/${PF}/html:" \
		Makefile.in src/*.mak || die "sed failed"
}

src_compile() {
	econf $(use_with X x) \
		$(use_with jpeg2k jasper) \
		$(use_enable cups) \
		$(use_enable gtk) \
		--with-ijs \
		--with-jbig2dec \
		--disable-compile-inits \
		--enable-dynamic \
		|| die "econf failed"
	
	emake -j1 so all || die "emake failed"

	cd ijs
	econf || die "ijs econf failed"
	emake || die "ijs emake failed"
}

src_install() {
	emake DESTDIR="${D}" install-so install || die "emake install failed"

	rm -fr "${D}"/usr/share/doc/${PF}/html/{README,PUBLIC}
	dodoc doc/README

	cd ${S}/ijs
	emake DESTDIR="${D}" install || die "emake ijs install failed"
}
