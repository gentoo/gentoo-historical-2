# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsamixergui/alsamixergui-0.9.0.1.2.ebuild,v 1.9 2004/03/16 16:27:17 eradicator Exp $

DESCRIPTION="AlsaMixerGui - a FLTK based amixer Frontend"
HOMEPAGE="http://www.iua.upf.es/~mdeboer/projects/alsamixergui/"
LICENSE="GPL-2"

DEPEND="virtual/alsa
	>=media-libs/alsa-lib-0.9.0_rc1
	>=media-sound/alsa-utils-0.9.0_rc1
	>=x11-libs/fltk-1.1.0_rc4"

SLOT="0"
KEYWORDS="x86 ~ppc"

# Weird version numbering.
# I'm mapping rc1-2 into "1.2" suffix for the package.
NATIVE_VER=0.9.0rc1-2
S=${WORKDIR}/${PN}-${NATIVE_VER}
SRC_URI="ftp://www.iua.upf.es/pub/mdeboer/projects/alsamixergui/${PN}-${NATIVE_VER}.tar.gz"

src_unpack() {
	## A temporary measure to get around incompatibility with fltk
	## library.  See bug #6217.
	unpack ${A}
	cd ${S}
	sed -e 's/^numericsort/fl_numericsort/' <configure >configure.hacked
	mv configure.hacked configure
	chmod 755 configure
}

src_compile() {
	cd ${S}
	./configure || die "./configure failed"
	make || die
}

src_install () {
	cd ${S}
	make DESTDIR=${D} install || die
	dodoc COPYING README AUTHORS ChangeLog
}
