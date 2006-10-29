# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-patch-bay/alsa-patch-bay-1.0.0-r1.ebuild,v 1.7 2006/10/29 23:54:27 flameeyes Exp $

inherit eutils

DESCRIPTION="Graphical patch bay for the ALSA sequencer API."
HOMEPAGE="http://pkl.net/~node/software/alsa-patch-bay/index.html"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="x86 amd64 ~ppc"

IUSE="fltk"

# The package defaults to the gtkmm graphics library.
# To use fltk instead, do $ USE="fltk" emerge alsa-patch-bay
# Note: fltk is not an official USE flag, and the dependency on
# it may go away in the future.
DEPEND="!fltk? ( =dev-cpp/gtkmm-2.2* )
	fltk? ( >=x11-libs/fltk-1.1.2 )
	>=media-libs/alsa-lib-0.9.0_rc1"

SRC_URI="http://pkl.net/~node/software/${P}.tar.gz"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-amd64.patch
}

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
	einstall APB_DESKTOP_PREFIX=${D}/usr/share || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}

pkg_preinst() {
	if [ -e ${D}/usr/bin/jack-patch-bay ]
	then
		rm ${D}/usr/bin/jack-patch-bay
		ln -s alsa-patch-bay ${D}/usr/bin/jack-patch-bay
	fi
}
