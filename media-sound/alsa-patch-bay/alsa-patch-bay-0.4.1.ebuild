# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-patch-bay/alsa-patch-bay-0.4.1.ebuild,v 1.1 2003/03/04 23:24:23 agenkin Exp $

DESCRIPTION="Graphical patch bay for the ALSA sequencer API."
HOMEPAGE="http://pkl.net/~node/alsa-patch-bay.html"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="-x86"

IUSE=""

# The package defaults to the gtkmm graphics library.
# To use fltk instead, do $ USE="fltk" emerge alsa-patch-bay
# Note: fltk is not an official USE flag, and the dependency on
# it may go away in the future.
DEPEND="!fltk? x11-libs/gtkmm
        fltk? >=x11-libs/fltk-1.1.2
        >=media-sound/alsa-driver-0.9.0_rc1
        >=media-libs/alsa-lib-0.9.0_rc1
        >=media-sound/alsa-utils-0.9.0_rc1"

SRC_URI="http://pkl.net/~node/software/${P}.tar.gz"
S=${WORKDIR}/${P}

src_compile() {
        local myconf
        use fltk || myconf="--disable-fltk"
        ./configure ${myconf} \
                --host=${CHOST} \
                --prefix=/usr \
                --infodir=/usr/share/info \
                --mandir=/usr/share/man || die "./configure failed"
        emake || die
}

src_install() {
	einstall || die
        dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README THANKS TODO
}
