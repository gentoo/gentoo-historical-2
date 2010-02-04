# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/luatex/luatex-0.50.0-r1.ebuild,v 1.3 2010/02/04 22:19:04 maekke Exp $

EAPI="2"

inherit libtool multilib eutils toolchain-funcs autotools

PATCHLEVEL="17"

DESCRIPTION="An extended version of pdfTeX using Lua as an embedded scripting language."
HOMEPAGE="http://www.luatex.org/"
SRC_URI="http://foundry.supelec.fr/gf/download/frsrelease/364/1424/${PN}-beta-${PV}.tar.bz2
	mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="dev-libs/zziplib
	media-libs/libpng
	virtual/poppler
	sys-libs/zlib
	virtual/tex-base"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2.6
	dev-util/pkgconfig"

S="${WORKDIR}/${PN}-beta-${PV}/source"
PRELIBS="libs/dummy libs/obsdcompat texk/kpathsea"
kpathsea_extraconf="--disable-shared --disable-largefile"

src_prepare() {
	local EPATCH_EXCLUDE=""
	has_version '>=virtual/poppler-0.11.3' || EPATCH_EXCLUDE="040_all_poppler-0.11.3.patch"
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
	eautoreconf
	elibtoolize
}

src_configure() {
	# Too many regexps use A-Z a-z constructs, what causes problems with locales
	# that don't have the same alphabetical order than ascii. Bug #244619
	# So we set LC_ALL to C in order to avoid problems.
	export LC_ALL=C

	local myconf
	myconf=""
	has_version '>=app-text/texlive-core-2009' && myconf="--with-system-kpathsea"

	cd "${S}/texk/web2c"
	econf \
		--disable-cxx-runtime-hack \
		--disable-afm2pl    \
		--disable-aleph		\
		--disable-bibtex	\
		--disable-bibtex8	\
		--disable-cfftot1	\
		--disable-cjkutils	\
		--disable-detex		\
		--disable-devnag	\
		--disable-dialog	\
		--disable-dtl		\
		--enable-dump-share	\
		--disable-dvi2tty	\
		--disable-dvidvi	\
		--without-dviljk    \
	    --disable-dvipdfm	\
	    --disable-dvipdfmx	\
	    --disable-dvipos	\
	    --disable-dvipsk	\
		--disable-gsftopk	\
		--disable-ipc		\
	    --disable-lacheck	\
	    --disable-lcdf-typetools \
		--disable-makeindexk \
	    --disable-mf		\
	    --disable-mmafm		\
	    --disable-mmpfb		\
	    --disable-mp		\
	    --disable-musixflx	\
	    --disable-otfinfo	\
	    --disable-otftotfm	\
	    --disable-pdfopen	\
	    --disable-pdftex	\
	    --disable-ps2eps	\
	    --disable-ps2pkm	\
	    --disable-psutils	\
	    --disable-seetexk	\
	    --disable-t1dotlessj  \
	    --disable-t1lint	\
	    --disable-t1rawafm	\
	    --disable-t1reencode	\
	    --disable-t1testpage \
		--disable-t1utils	\
	    --disable-tex		\
	    --disable-tex4htk	\
	    --disable-tpic2pdftex	\
	    --disable-ttf2pk	\
	    --disable-ttfdump	\
	    --disable-ttftotype42	\
	    --disable-vlna		\
	    --disable-web-progs \
	    --disable-xdv2pdf	\
	    --disable-xdvipdfmx \
		--without-x			\
	    --without-system-kpathsea	\
	    --with-system-gd	\
	    --with-system-libpng	\
	    --with-system-teckit \
	    --with-system-zlib \
	    --with-system-t1lib \
		--with-system-xpdf \
	    --disable-largefile \
	    --disable-multiplatform \
		--disable-shared \
		${myconf}

	for i in ${PRELIBS} ; do
		einfo "Configuring $i"
		local j=$(basename $i)_extraconf
		local myconf
		eval myconf=\${$j}
		cd "${S}/${i}"
		econf ${myconf}
	done
}

src_compile() {
	for i in ${PRELIBS} ; do
		cd "${S}/${i}"
		emake || die "failed to build ${i}"
	done
	cd "${WORKDIR}/${PN}-beta-${PV}/source/texk/web2c"
	emake || die "failed to build luatex"
}

src_install() {
	cd "${WORKDIR}/${PN}-beta-${PV}/source/texk/web2c"
	emake DESTDIR="${D}" bin_PROGRAMS="luatex" SUBDIRS="" nodist_man_MANS="" \
		install || die

	dodoc "${WORKDIR}/${PN}-beta-${PV}/README"
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins "${WORKDIR}/${PN}-beta-${PV}/manual/"*.pdf
	fi
}

pkg_postinst() {
	if ! has_version '>=dev-texlive/texlive-basic-2008' ; then
		elog "Please note that this package does not install much files, mainly the"
		elog "${PN} executable that will need other files in order to be useful.."
		elog "Please consider installing a recent TeX distribution"
		elog "like TeX Live 2008 to get the full power of ${PN}"
	fi
	if [ "$ROOT" = "/" ] && [ -x /usr/bin/fmtutil-sys ] ; then
		einfo "Rebuilding formats"
		/usr/bin/fmtutil-sys --all &> /dev/null
	else
		ewarn "Cannot run fmtutil-sys for some reason."
		ewarn "Your formats might be inconsistent with your installed ${PN} version"
		ewarn "Please try to figure what has happened"
	fi
}
