# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tesseract/tesseract-1.03-r1.ebuild,v 1.4 2007/02/26 18:42:49 mcummings Exp $

inherit eutils multilib

DESCRIPTION="A commercial quality OCR engine developed at HP in the 80's and early 90's."
HOMEPAGE="http://sourceforge.net/projects/tesseract-ocr/"
SRC_URI="mirror://sourceforge/tesseract-ocr/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="media-libs/tiff"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}"/tesseract-1.0.xterm-path.patch
}

src_compile() {
	econf --with-libtiff=no || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}"

	dodir "${dest}"

	exeinto "${dest}"
	doexe ccmain/tesseract

	dodir "${dest}/tessdata/configs"
	dodir "${dest}/tessdata/tessconfigs"

	insinto "${dest}/tessdata"
	doins tessdata/*

	insinto "${dest}/tessdata/configs"
	doins tessdata/configs/*

	insinto "${dest}/tessdata/tessconfigs"
	doins tessdata/tessconfigs/*

	dodoc README AUTHORS phototest.tif

	echo -e "#!/bin/sh\n${dest}/${PN} \"\${@}\"" > ${PN}.sh
	newbin ${PN}.sh ${PN}
}
