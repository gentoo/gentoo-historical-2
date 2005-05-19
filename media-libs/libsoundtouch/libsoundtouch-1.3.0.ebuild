# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsoundtouch/libsoundtouch-1.3.0.ebuild,v 1.1 2005/05/19 02:47:17 kito Exp $

IUSE="static"

S="${WORKDIR}/SoundTouch-${PV}"

DESCRIPTION="Audio processing library for changing tempo, pitch and playback rates."
HOMEPAGE="http://sky.prohosting.com/oparviai/soundtouch/"
SRC_URI="http://sky.prohosting.com/oparviai/soundtouch/soundtouch_v${PV}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-macos"

RDEPEND="virtual/libc"
DEPEND="app-arch/unzip"

src_unpack() {
	unpack ${A} || die "unpack failed"
	cd ${S}

	# change sample type from integer to float (more accurate)
	sed -i -e "s|#define INTEGER_SAMPLES|//#define INTEGER_SAMPLES|g" \
		-e "s|//#define FLOAT_SAMPLES|#define FLOAT_SAMPLES|g" include/STTypes.h
}

src_compile() {
	econf $myconf \
		$(use_enable static) \
		--with-pic || die "./configure failed"
	# fixes C(XX)FLAGS from configure, so we can use *ours*
	emake CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" pkgdocdir="/usr/share/doc/${PF}" install || die
	rm -f ${D}/usr/share/doc/${PF}/COPYING.TXT  # remove obsolete LICENCE file
}
