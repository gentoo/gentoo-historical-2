# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/unifont/unifont-1.0-r1.ebuild,v 1.1 2004/01/22 06:55:36 usata Exp $

IUSE="X"

DESCRIPTION="X11 dual-width GNU unicode font"
HOMEPAGE="http://czyborra.com/"
SRC_URI="http://ftp.debian.org/debian/pool/main/u/unifont/${P/-/_}.orig.tar.gz
	http://ftp.debian.org/debian/pool/main/u/unifont/${P/-/_}-1.diff.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86"

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
}

src_install() {

	insinto ${FONTPATH}

	doins unifont.pcf.gz
	use X && mkfontdir ${D}${FONTPATH}
}
