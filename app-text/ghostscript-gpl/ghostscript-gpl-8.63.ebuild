# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ghostscript-gpl/ghostscript-gpl-8.63.ebuild,v 1.9 2008/12/11 17:51:54 jer Exp $

inherit autotools eutils versionator flag-o-matic

DESCRIPTION="GPL Ghostscript - the most current Ghostscript, AFPL, relicensed"
HOMEPAGE="http://ghostscript.com/"

MY_P=${P/-gpl}
GSDJVU_PV=1.3
PVM=$(get_version_component_range 1-2)
SRC_URI="cjk? ( ftp://ftp.gyve.org/pub/gs-cjk/adobe-cmaps-200406.tar.gz
		ftp://ftp.gyve.org/pub/gs-cjk/acro5-cmaps-2001.tar.gz )
	!bindist? ( djvu? ( mirror://sourceforge/djvu/gsdjvu-${GSDJVU_PV}.tar.gz ) )
	mirror://sourceforge/ghostscript/${MY_P}.tar.bz2
	mirror://gentoo/${P}-patchset-2.tar.bz2"

LICENSE="GPL-2 CPL-1.0"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="bindist cairo cjk cups djvu gtk jpeg2k X"

COMMON_DEPEND="media-libs/fontconfig
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.2.5
	>=media-libs/tiff-3.7
	>=sys-libs/zlib-1.1.4
	!bindist? ( djvu? ( app-text/djvu ) )
	cairo? ( x11-libs/cairo )
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
		cat "${WORKDIR}/patches/ghostscript-esp-8.15.2-cidfmap.cjk" >> "${S}/lib/cidfmap"
		cat "${WORKDIR}/patches/ghostscript-esp-8.15.2-FAPIcidfmap.cjk" >> "${S}/lib/FAPIcidfmap"
		cd "${S}/Resource"
		unpack adobe-cmaps-200406.tar.gz
		unpack acro5-cmaps-2001.tar.gz
		cd "${WORKDIR}"
	fi

	cd "${S}"

	# remove internal copies of expat, jasper, jpeg, libpng and zlib
	rm -rf "${S}/expat"
	rm -rf "${S}/jasper"
	rm -rf "${S}/jpeg"
	rm -rf "${S}/libpng"
	rm -rf "${S}/zlib"
	# remove internal urw-fonts
	rm -rf "${S}/Resource/Font"

	# Fedora patches
	# http://cvs.fedora.redhat.com/viewcvs/devel/ghostscript/
	epatch "${WORKDIR}/patches/${PN}-8.60-fPIC.patch"
	epatch "${WORKDIR}/patches/${PN}-8.61-multilib.patch"
	epatch "${WORKDIR}/patches/${PN}-8.60-noopt.patch"
	epatch "${WORKDIR}/patches/${PN}-8.60-scripts.patch"
	epatch "${WORKDIR}/patches/${PN}-8.62-system-jasper.patch"
	epatch "${WORKDIR}/patches/${PN}-8.62-pksmraw.patch"

	# Gentoo patches
	# Upstream bug #689999, already fixed in ghostscript trunk.
	epatch "${WORKDIR}/patches/${PN}-8.63-cairo-automagic.patch"

	if use bindist && use djvu ; then
		ewarn "You have bindist in your USE, djvu support will NOT be compiled!"
		ewarn "See http://djvu.sourceforge.net/gsdjvu/COPYING for details on licensing issues."
	fi

	if ! use bindist && use djvu ; then
		unpack gsdjvu-${GSDJVU_PV}.tar.gz
		cp gsdjvu-${GSDJVU_PV}/gsdjvu "${S}"
		cp gsdjvu-${GSDJVU_PV}/gdevdjvu.c "${S}/src"
		epatch "${WORKDIR}/patches/${PN}-8.61-gsdjvu-1.3.patch"
		cp gsdjvu-${GSDJVU_PV}/ps2utf8.ps "${S}/lib"
		cp "${S}/src/contrib.mak" "${S}/src/contrib.mak.gsdjvu"
		grep -q djvusep "${S}/src/contrib.mak" || \
			cat gsdjvu-${GSDJVU_PV}/gsdjvu.mak >> "${S}/src/contrib.mak"

		# install ps2utf8.ps, bug #197818
		sed -i -e '/$(EXTRA_INIT_FILES)/ a\ps2utf8.ps \\' "${S}/src/unixinst.mak" \
		|| die "sed failed"
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

	cd "${S}/ijs"
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable cairo) \
		$(use_enable cups) \
		$(use_enable gtk) \
		$(use_with jpeg2k jasper) \
		$(use_with X x) \
		--disable-compile-inits \
		--enable-dynamic \
		--enable-fontconfig \
		--with-drivers=ALL \
		--with-ijs \
		--with-jbig2dec \
	|| die "econf failed"

	if ! use bindist && use djvu ; then
		sed -i -e 's!$(DD)bbox.dev!& $(DD)djvumask.dev $(DD)djvusep.dev!g' Makefile
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

	rm -rf "${D}/usr/share/doc/${PF}/html/"{README,PUBLIC}
	dodoc doc/README || die "dodoc install failed"

	cd "${S}/ijs"
	emake DESTDIR="${D}" install || die "emake ijs install failed"
}
