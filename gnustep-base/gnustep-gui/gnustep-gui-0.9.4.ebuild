# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-gui/gnustep-gui-0.9.4.ebuild,v 1.4 2004/09/27 00:20:17 fafhrd Exp $

inherit gnustep

DESCRIPTION="It is a library of graphical user interface classes written completely in the Objective-C language."
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"

KEYWORDS="~x86"
SLOT="0"
LICENSE="LGPL-2.1"

IUSE="${IUSE} jpeg gif png gsnd doc cups camaelon"
DEPEND="${GNUSTEP_BASE_DEPEND}
	virtual/x11
	=media-libs/tiff-3*
	jpeg? =media-libs/jpeg-6b*
	gif? =media-libs/libungif-4.1*
	png? =media-libs/libpng-1.2*
	gsnd? =media-libs/audiofile-0.2*
	cups? =net-print/cups-1.1*
	=app-text/aspell-0.50*"
RDEPEND="${DEPEND}
	${DOC_RDEPEND}"
PDEPEND="camaelon? =gnustep-libs/camaelon-0.1"

src_unpack() {
	unpack ${A}
	cd ${S}
	if use camaelon
	then
		epatch ${FILESDIR}/${P}-camaelon.patch
	fi
}

src_compile() {
	egnustep_env

	myconf="--with-tiff-include=/usr/include --with-tiff-library=/usr/lib"
	myconf="$myconf `use_enable gsnd`"
	use gsnd && myconf="$myconf --with-audiofile-include=/usr/include --with-audiofile-lib=/usr/lib"
	use gif && myconf="$myconf --enable-ungif"
	myconf="$myconf `use_enable jpeg`"
	myconf="$myconf `use_enable png`"
	myconf="$myconf `use_enable cups`"
	econf $myconf || die "configure failed"

	egnustep_make || die
}

