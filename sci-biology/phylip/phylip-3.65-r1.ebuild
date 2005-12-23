# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/phylip/phylip-3.65-r1.ebuild,v 1.4 2005/12/23 19:37:35 dertobi123 Exp $

inherit toolchain-funcs

DESCRIPTION="PHYLIP - The PHYLogeny Inference Package"
LICENSE="freedist"
HOMEPAGE="http://evolution.genetics.washington.edu/phylip.html"
SRC_URI="ftp://evolution.genetics.washington.edu/pub/${PN}/${P}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="ppc ~ppc-macos x86"

DEPEND="virtual/x11"

S="${WORKDIR}/${PN}${PV}/src"

src_compile() {
	sed -e "s/CFLAGS  = -O3 -fomit-frame-pointer/CFLAGS = ${CFLAGS}/" \
		-e "s/CC        = cc/CC        = $(tc-getCC)/" \
		-e "s/DC        = cc/DC        = $(tc-getCC)/" \
		-i Makefile || die "Patching Makefile failed."
	mkdir ../fonts
	emake -j1 all put || die "Compilation failed."
	mv ../exe/font* ../fonts || die "Font move failed."
	mv ../exe/factor ../exe/factor-${PN} || die "Renaming factor failed."
}

src_install() {
	cd "${WORKDIR}/${PN}${PV}"

	dobin exe/* || "Failed to install programs."

	dodoc "${FILESDIR}"/README.Gentoo || die "Failed to install Gentoo notes."

	dohtml phylip.html || "Failed to install HTML documentation index."
	insinto /usr/share/doc/${PF}/html/doc
	doins doc/* || "Failed to install HTML documentation."

	insinto /usr/share/${PN}/fonts
	doins fonts/* || die "Fonts installation failed."
}
