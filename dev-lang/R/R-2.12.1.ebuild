# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/R/R-2.12.1.ebuild,v 1.2 2011/01/04 20:51:10 bicatali Exp $

EAPI=2
inherit eutils flag-o-matic bash-completion versionator

DESCRIPTION="Language and environment for statistical computing and graphics"
HOMEPAGE="http://www.r-project.org/"
SRC_URI="mirror://cran/src/base/R-2/${P}.tar.gz
	bash-completion? ( mirror://gentoo/R.bash_completion.bz2 )"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE="doc java jpeg lapack minimal nls perl png profile readline static-libs threads tk X cairo"

# common depends
CDEPEND="dev-libs/libpcre
	app-arch/bzip2
	virtual/blas
	app-text/ghostscript-gpl
	cairo? ( x11-libs/cairo[X]
		|| ( >=x11-libs/pango-1.20[X] <x11-libs/pango-1.20 ) )
	jpeg? ( virtual/jpeg )
	lapack? ( virtual/lapack )
	perl? ( dev-lang/perl )
	png? ( media-libs/libpng )
	readline? ( sys-libs/readline )
	tk? ( dev-lang/tk )
	X? ( x11-libs/libXmu x11-misc/xdg-utils )"

DEPEND="${CDEPEND}
	dev-util/pkgconfig
	doc? ( virtual/latex-base
	  || ( dev-texlive/texlive-fontsrecommended
		   app-text/ptex ) )"

RDEPEND="${CDEPEND}
	app-arch/unzip
	app-arch/zip
	java? ( >=virtual/jre-1.5 )"

RESTRICT="minimal? ( test )"

R_DIR=/usr/$(get_libdir)/${PN}

pkg_setup() {
	filter-ldflags -Wl,-Bdirect -Bdirect
	# avoid using existing R installation
	unset R_HOME
}

src_prepare() {
	# fix ocasional failure with parallel install (bug #322965)
	epatch "${FILESDIR}"/${PN}-2.11.1-parallel.patch
	# respect ldflags on rscript
	epatch "${FILESDIR}"/${PN}-2.12.1-ldflags.patch

	# fix packages.html for doc (bug #205103)
	# check in later versions if fixed
	sed -i \
		-e "s:../../library:../../../../$(get_libdir)/R/library:g" \
		src/library/tools/R/packageshtml.R \
		|| die "sed failed"

	# fix Rscript
	sed -i \
		-e "s:-DR_HOME='\"\$(rhome)\"':-DR_HOME='\"${R_DIR}\"':" \
		src/unix/Makefile.in || die "sed unix Makefile failed"

	# fix HTML links to manual (bug #273957)
	sed -i -e 's:\.\./manual/:manual/:g' $(grep -Flr ../manual/ doc) \
		|| die "sed for HTML links to manual failed"

	use lapack && \
		export LAPACK_LIBS="$(pkg-config --libs lapack)"

	if use X; then
		export R_BROWSER="$(type -p xdg-open)"
		export R_PDFVIEWER="$(type -p xdg-open)"
	fi
	use perl && \
		export PERL5LIB="${S}/share/perl:${PERL5LIB:+:}${PERL5LIB}"
}

src_configure() {
	econf \
		--enable-R-shlib \
		--with-system-zlib \
		--with-system-bzlib \
		--with-system-pcre \
		--with-blas="$(pkg-config --libs blas)" \
		--docdir=/usr/share/doc/${PF} \
		rdocdir=/usr/share/doc/${PF} \
		$(use_enable nls) \
		$(use_enable profile R-profiling) \
		$(use_enable profile memory-profiling) \
		$(use_enable static-libs static) \
		$(use_enable static-libs R-static-lib) \
		$(use_enable threads) \
		$(use_with lapack) \
		$(use_with tk tcltk) \
		$(use_with jpeg jpeglib) \
		$(use_with !minimal recommended-packages) \
		$(use_with png libpng) \
		$(use_with readline) \
		$(use_with cairo) \
		$(use_with X x)
}

src_compile(){
	export VARTEXFONTS="${T}/fonts"
	emake || die "emake failed"
	RMATH_V=0.0.0
	emake -C src/nmath/standalone \
		libRmath_la_LDFLAGS=-Wl,-soname,libRmath.so.${RMATH_V} \
		|| die "emake math library failed"
	if use doc; then
		emake info pdf || die "emake docs failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use doc; then
		emake DESTDIR="${D}" \
			install-info install-pdf || die "emake install docs failed"
		dosym /usr/share/doc/${PF}/manual /usr/share/doc/${PF}/html/manual
	fi

	# standalone math lib install (-j1 basically harmless)
	emake \
		-C src/nmath/standalone \
		DESTDIR="${D}" install \
		|| die "emake install math library failed"

	local mv=$(get_major_version ${RMATH_V})
	mv  "${D}"/usr/$(get_libdir)/libRmath.so \
		"${D}"/usr/$(get_libdir)/libRmath.so.${RMATH_V}
	dosym libRmath.so.${RMATH_V} /usr/$(get_libdir)/libRmath.so.${mv}
	dosym libRmath.so.${mv} /usr/$(get_libdir)/libRmath.so

	# env file
	cat > 99R <<-EOF
		LDPATH=${R_DIR}/lib
		R_HOME=${R_DIR}
	EOF
	doenvd 99R || die "doenvd failed"
	dobashcompletion "${WORKDIR}"/R.bash_completion
}

pkg_postinst() {
	if use java; then
		einfo "Re-initializing java paths for ${P}"
		R CMD javareconf
	fi
}
