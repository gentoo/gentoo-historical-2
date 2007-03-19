# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tetex/tetex-3.0_p1-r2.ebuild,v 1.7 2007/03/19 18:58:55 nattfodd Exp $

inherit tetex-3 flag-o-matic versionator virtualx

SMALL_PV=$(get_version_component_range 1-2 ${PV})
TETEX_TEXMF_PV=${SMALL_PV}
S=${WORKDIR}/tetex-src-${SMALL_PV}

TETEX_SRC="tetex-src-${PV}.tar.gz"
TETEX_TEXMF="tetex-texmf-${TETEX_TEXMF_PV:-${TETEX_PV}}.tar.gz"
#TETEX_TEXMF_SRC="tetex-texmfsrc-${TETEX_TEXMF_PV:-${TETEX_PV}}.tar.gz"
TETEX_TEXMF_SRC=""

DESCRIPTION="a complete TeX distribution"
HOMEPAGE="http://tug.org/teTeX/"

SRC_PATH_TETEX=ftp://cam.ctan.org/tex-archive/systems/unix/teTeX/current/distrib
SRC_URI="mirror://gentoo/${TETEX_SRC}
	${SRC_PATH_TETEX}/${TETEX_TEXMF}
	mirror://gentoo/${P}-gentoo.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sparc ~x86"

# these are defined in tetex.eclass and tetex-3.eclass
IUSE=""
DEPEND=""

src_unpack() {
	tetex-3_src_unpack
	cd ${S}
	epatch ${FILESDIR}/${PN}-${SMALL_PV}-kpathsea-pic.patch

	# bug 85404
	epatch ${FILESDIR}/${PN}-${SMALL_PV}-epstopdf-wrong-rotation.patch

	epatch ${FILESDIR}/${P}-amd64-xdvik-wp.patch
	epatch ${FILESDIR}/${P}-mptest.patch

	#bug 98029
	epatch ${FILESDIR}/${P}-fmtutil-etex.patch

	#bug 115775
	epatch ${FILESDIR}/${P}-xpdf-vulnerabilities.patch

	# bug 94860
	epatch ${FILESDIR}/${P}-pdftosrc-install.patch
}

src_compile() {
	#bug 119856
	export LC_ALL=C

	tetex-3_src_compile
}

src_test() {
	fmtutil --fmtdir "${S}/texk/web2c" --all
	# The check target tries to access X display, bug #69439.
	Xmake check || die "Xmake check failed."
}

src_install() {
	insinto /usr/share/texmf/dvips/pstricks
	doins ${FILESDIR}/pst-circ.pro

	# install pdftosrc man page, bug 94860
	doman ${S}/texk/web2c/pdftexdir/pdftosrc.1

	tetex-3_src_install

	# virtex was removed from tetex-3
	dosym /usr/bin/tex /usr/bin/virtex
	dosym /usr/bin/pdftex /usr/bin/pdfvirtex
}
