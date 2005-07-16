# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-gui/gnustep-gui-0.9.5_pre20050312-r1.ebuild,v 1.4 2005/07/16 15:49:54 swegener Exp $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="savannah.gnu.org:/cvsroot/gnustep"
ECVS_USER="anoncvs"
ECVS_AUTH="ext"
ECVS_MODULE="gnustep/core/gui"
ECVS_CO_OPTS="-P -D ${PV/*_pre}"
ECVS_UP_OPTS="-dP -D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/savannah.gnu.org-gnustep"
inherit gnustep cvs

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="It is a library of graphical user interface classes written completely in the Objective-C language."
HOMEPAGE="http://www.gnustep.org"

KEYWORDS="~ppc ~x86 ~amd64 ~sparc ~alpha"
SLOT="0"
LICENSE="LGPL-2.1"

IUSE="cups gif gsnd jpeg png"
DEPEND="${GNUSTEP_BASE_DEPEND}
	>=gnustep-base/gnustep-base-1.10.2_pre20050312
	virtual/x11
	>=media-libs/tiff-3
	jpeg? ( >=media-libs/jpeg-6b )
	gif? ( >=media-libs/giflib-4.1 )
	png? ( >=media-libs/libpng-1.2 )
	gsnd? ( >=media-libs/audiofile-0.2 )
	cups? ( >=net-print/cups-1.1 )
	app-text/aspell"
RDEPEND="${DEPEND}
	${DOC_RDEPEND}"

egnustep_install_domain "System"

src_unpack() {
	cvs_src_unpack ${A}
	cd ${S}
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/gui-use-giflib.patch.bz2
}

src_compile() {
	egnustep_env

	myconf="--with-tiff-include=/usr/include --with-tiff-library=/usr/lib"
	myconf="$myconf `use_enable gsnd`"
	use gsnd && myconf="$myconf --with-audiofile-include=/usr/include --with-audiofile-lib=/usr/lib"
	use gif && myconf="$myconf --disable-ungif --enable-giflib"
	myconf="$myconf `use_enable jpeg`"
	myconf="$myconf `use_enable png`"
	myconf="$myconf `use_enable cups`"
	econf $myconf || die "configure failed"

	egnustep_make || die
}

