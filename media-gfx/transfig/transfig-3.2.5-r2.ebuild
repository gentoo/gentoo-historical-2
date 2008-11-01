# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/transfig/transfig-3.2.5-r2.ebuild,v 1.3 2008/11/01 18:19:05 nixnut Exp $

inherit toolchain-funcs eutils flag-o-matic

MY_P=${PN}.${PV}

DESCRIPTION="A set of tools for creating TeX documents with graphics which can be printed in a wide variety of environments"
SRC_URI="http://xfig.org/software/xfig/${PV}/${MY_P}.tar.gz
	mirror://gentoo/transfig-3.2.5-fig2mpdf.patch.bz2"
HOMEPAGE="http://www.xfig.org"
IUSE=""

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 hppa ~ia64 ppc ~ppc64 ~sparc ~x86"

RDEPEND="x11-libs/libXpm
	>=media-libs/jpeg-6
	media-libs/libpng
	x11-apps/rgb"
DEPEND="${RDEPEND}
	x11-misc/imake
	app-text/rman"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	find "${S}" -type f -exec chmod -x \{\} \;
	epatch "${FILESDIR}"/${P}-arrows-and-QA.patch
	epatch "${FILESDIR}"/${P}-imagemap.patch
	epatch "${FILESDIR}"/${P}-SetFigFont-params.patch
	epatch "${FILESDIR}"/${P}-displaywho.patch
	epatch "${FILESDIR}"/${P}-locale.patch
	epatch "${FILESDIR}"/${P}-fig2ps2tex_bashisms.patch
	epatch "${WORKDIR}"/${P}-fig2mpdf.patch
}

sed_Imakefile() {
	# see fig2dev/Imakefile for details
	vars2subs="BINDIR=/usr/bin
			MANDIR=/usr/share/man/man\$\(MANSUFFIX\)
			XFIGLIBDIR=/usr/share/xfig
			USEINLINE=-DUSE_INLINE
			RGB=/usr/share/X11/rgb.txt
			FIG2DEV_LIBDIR=/usr/share/fig2dev"

	for variable in ${vars2subs} ; do
		varname=${variable%%=*}
		varval=${variable##*=}
		sed -i "s:^\(XCOMM\)*[[:space:]]*${varname}[[:space:]]*=.*$:${varname} = ${varval}:" "$@"
	done
}

src_compile() {
	sed_Imakefile fig2dev/Imakefile fig2dev/dev/Imakefile

	# without append transfig compiles with warining
	# incompatible implicit declaration of built-in function ‘strlen’
	# but are we really SVR4?
	#append-flags -DSVR4
	xmkmf || die "xmkmf failed"
	make Makefiles || die "make Makefiles failed"

	emake CC="$(tc-getCC)" LOCAL_LDFLAGS="${LDFLAGS}" CDEBUGFLAGS="${CFLAGS}" \
	USRLIBDIR=/usr/$(get_libdir) || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" \
		${transfig_conf} install install.man || die

	insinto /usr/share/fig2dev/
	doins "${FILESDIR}/transfig-ru_RU.CP1251.ps" || die
	doins "${FILESDIR}/transfig-ru_RU.KOI8-R.ps" || die
	doins "${FILESDIR}/transfig-uk_UA.KOI8-U.ps" || die
	#Install docs
	dodoc README CHANGES LATEX.AND.XFIG NOTES
}
