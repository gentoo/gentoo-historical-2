# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-midi/xmms-midi-0.03.ebuild,v 1.3 2003/07/12 18:40:48 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Timidity++ Dependent MIDI Plugun for XMMS"
HOMEPAGE="http://ban.joh.cam.ac.uk/~cr212/xmms-midi/"
SRC_URI="http://ban.joh.cam.ac.uk/~cr212/xmms-midi/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="media-sound/xmms
        media-sound/timidity++"

src_compile() {
	econf \
		--prefix=/usr/lib
		--with-xmms-prefix=/usr/include/xmms
	emake || die
}

src_install() {
	make DESTDIR=${D} libdir=/usr/lib/xmms/Input install || die
	dodoc AUTHORS COPYING NEWS README
}

pkg_postinst() {
	if [ ! -f /etc/timidity.cfg ]
	then
		einfo "*** WARNING: XMMS will play all MIDI files silently until a"
		einfo "working timidity.cfg has been placed in /etc!"
	fi
}
