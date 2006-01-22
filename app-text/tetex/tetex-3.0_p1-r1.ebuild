# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tetex/tetex-3.0_p1-r1.ebuild,v 1.1 2006/01/22 16:35:23 nattfodd Exp $

inherit tetex-3 flag-o-matic versionator

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
SRC_URI="http://dev.gentoo.org/~nattfodd/tetex/${TETEX_SRC}
	${SRC_PATH_TETEX}/${TETEX_TEXMF}
	http://dev.gentoo.org/~nattfodd/tetex/${P}-gentoo.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~ppc-macos ~s390 ~sparc ~x86"

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
}

src_test() {
	fmtutil --fmtdir "${S}/texk/web2c" --all
	make check
}

src_install() {
	tetex-3_src_install

	# virtex was removed from tetex-3
	dosym /usr/bin/tex /usr/bin/virtex
	dosym /usr/bin/pdftex /usr/bin/pdfvirtex
}

pkg_postinst() {
	einfo ""
	einfo "tetex-3.0_p1-r1 makes changes in /etc/texmf/fmtutil/00fmtutil.cnf"
	einfo "After you update this file, please run as root"
	einfo "  fmtutil-sys --missing && fmtutil-sys --byfmt etex"
	einfo ""
}
