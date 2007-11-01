# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ghostscript-gpl/ghostscript-gpl-8.60.ebuild,v 1.7 2007/11/01 13:13:58 opfer Exp $

inherit autotools elisp-common eutils versionator flag-o-matic

DESCRIPTION="GPL Ghostscript - the most current Ghostscript, AFPL, relicensed"
HOMEPAGE="http://ghostscript.com"

MY_P=${P/-gpl}
GSDJVU_PV=1.2
PVM=$(get_version_component_range 1-2)
SRC_URI="cjk? ( ftp://ftp.gyve.org/pub/gs-cjk/adobe-cmaps-200406.tar.gz
		ftp://ftp.gyve.org/pub/gs-cjk/acro5-cmaps-2001.tar.gz )
	!bindist? ( djvu? ( mirror://sourceforge/djvu/gsdjvu-${GSDJVU_PV}.tar.gz ) )
	mirror://sourceforge/ghostscript/${MY_P}.tar.bz2"

LICENSE="GPL-2 CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ppc ~sh sparc x86 ~x86-fbsd"
IUSE="bindist cjk cups djvu gtk jpeg2k X"

COMMON_DEPEND="media-libs/fontconfig
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.2.5
	>=media-libs/tiff-3.7
	>=sys-libs/zlib-1.1.4
	!bindist? ( djvu? ( app-text/djvu ) )
	cups? ( >=net-print/cups-1.1.20 )
	gtk? ( >=x11-libs/gtk+-2.0 )
	jpeg2k? ( media-libs/jasper )
	X? ( x11-libs/libXt x11-libs/libXext )
	!app-text/ghostscript-esp
	!app-text/ghostscript-gnu"

DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"

RDEPEND="${COMMON_DEPEND}
	cjk? ( media-fonts/arphicfonts
		media-fonts/kochi-substitute
		media-fonts/baekmuk-fonts )
	media-fonts/gnu-gs-fonts-std"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A/adobe-cmaps-200406.tar.gz acro5-cmaps-2001.tar.gz}
	if use cjk ; then
		cat "${FILESDIR}/ghostscript-esp-8.15.2-cidfmap.cjk" >> "${S}/lib/cidfmap"
		cat "${FILESDIR}/ghostscript-esp-8.15.2-FAPIcidfmap.cjk" >> "${S}/lib/FAPIcidfmap"
		cd "${S}/Resource"
		unpack adobe-cmaps-200406.tar.gz
		unpack acro5-cmaps-2001.tar.gz
		cd "${WORKDIR}"
	fi

	cd "${S}"

	# Fedora patches
	# upstream bug http://bugs.ghostscript.com/show_bug.cgi?id=689393
	epatch "${FILESDIR}/ghostscript-8.60-ijs-krgb.patch"
	epatch "${FILESDIR}/ghostscript-8.60-fPIC.patch"
	epatch "${FILESDIR}/ghostscript-8.60-multilib.patch"
	epatch "${FILESDIR}/ghostscript-8.60-noopt.patch"
	epatch "${FILESDIR}/ghostscript-8.60-scripts.patch"

	# additional Gentoo patches
	epatch "${FILESDIR}/ghostscript-afpl-8.54-rinkj.patch"
	epatch "${FILESDIR}/ghostscript-8.60-include.patch"

	if use bindist && use djvu ; then
		ewarn "You have bindist in your USE, djvu support will NOT be compiled!"
		ewarn "See http://djvu.sourceforge.net/gsdjvu/COPYING for details on licensing issues."
	fi

	if ! use bindist && use djvu ; then
		unpack gsdjvu-${GSDJVU_PV}.tar.gz
		cp gsdjvu-${GSDJVU_PV}/gsdjvu "${S}"
		cp gsdjvu-${GSDJVU_PV}/gdevdjvu.c "${S}/src"
		epatch "${FILESDIR}/djvu-gs-gpl-8.60.patch"
		cp gsdjvu-${GSDJVU_PV}/ps2utf8.ps "${S}/lib"
		cp "${S}/src/contrib.mak" "${S}/src/contrib.mak.gsdjvu"
		grep -q djvusep "${S}/src/contrib.mak" || \
			cat gsdjvu-${GSDJVU_PV}/gsdjvu.mak >> "${S}/src/contrib.mak"
	fi

	if ! use gtk ; then
		sed -i "s:\$(GSSOX)::" src/*.mak || die "gsx sed failed"
		sed -i "s:.*\$(GSSOX_XENAME)$::" src/*.mak || die "gsxso sed failed"
	fi

	# search path fix
	sed -i -e "s:\$\(gsdatadir\)/lib:/usr/share/ghostscript/${PVM}/$(get_libdir):" \
		-e 's:$(gsdir)/fonts:/usr/share/fonts/default/ghostscript/:' \
		-e "s:exdir=.*:exdir=/usr/share/doc/${PF}/examples:" \
		-e "s:docdir=.*:docdir=/usr/share/doc/${PF}/html:" \
		-e "s:GS_DOCDIR=.*:GS_DOCDIR=/usr/share/doc/${PF}/html:" \
		src/Makefile.in src/*.mak || die "sed failed"

	cd "${S}"
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable cups) \
		$(use_enable gtk) \
		$(use_with jpeg2k jasper) \
		$(use_with X x) \
		--enable-dynamic \
		--enable-fontconfig \
		--with-drivers=ALL,rinkj \
		--with-ijs \
		--with-jbig2dec \
	|| die "econf failed"

	if ! use bindist && use djvu ; then
		sed -i -e 's!$(DD)bbox.dev!& $(DD)djvumask.dev $(DD)djvusep.dev!g'		Makefile
		sed -i -e 's:(/\(Resource/[a-zA-Z/]*\)):(\1) findlibfile {pop} {pop &}
		ifelse:' lib/gs_res.ps
	fi

	emake -j1 so all || die "emake failed"

	cd "${S}/ijs"
	econf || die "ijs econf failed"
	emake || die "ijs emake failed"
}

src_install() {
	emake DESTDIR="${D}" install-so install || die "emake install failed"

	if ! use bindist && use djvu ; then
		dobin gsdjvu || die "dobin gsdjvu install failed"
	fi

	rm -fr "${D}/usr/share/doc/${PF}/html/"{README,PUBLIC}
	dodoc doc/README || die "dodoc install failed"

	cd "${S}/ijs"
	emake DESTDIR="${D}" install || die "emake ijs install failed"
}
