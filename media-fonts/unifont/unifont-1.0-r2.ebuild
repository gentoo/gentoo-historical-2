# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/unifont/unifont-1.0-r2.ebuild,v 1.7 2004/09/29 06:59:29 usata Exp $

inherit eutils

IUSE="X"

DESCRIPTION="X11 GNU unicode font"
HOMEPAGE="http://czyborra.com/"
SRC_URI="mirror://debian/pool/main/u/unifont/${P/-/_}.orig.tar.gz
	mirror://debian/pool/main/u/unifont/${P/-/_}-1.diff.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="x86 ~amd64 ppc alpha"

DEPEND="dev-lang/perl
	virtual/x11"
RDEPEND=""

FONTPATH="/usr/share/fonts/${PN}"
S=${WORKDIR}/${PN}-dvdeug-${PV}

src_unpack() {

	unpack ${A}

	cd ${S}
	epatch ${WORKDIR}/${P/-/_}-1.diff
}

src_compile() {

	make || die
	make -f Makefile.new || die
}

src_install() {

	insinto ${FONTPATH}

	doins unifont*.gz
	use X && mkfontdir ${D}${FONTPATH}
}
