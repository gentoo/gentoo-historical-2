# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sox/sox-12.17.3-r2.ebuild,v 1.1 2002/10/16 14:09:24 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="The swiss army knife of sound processing programs"
HOMEPAGE="http://sox.sourceforge.net"
SRC_URI="http://download.sourceforge.net/sox/${P}.tar.gz"

KEYWORDS="x86 ppc"
SLOT="0"
LICENSE="LPGL-2.1"

DEPEND="virtual/glibc"

src_compile () {
	# Looks like support for alsa09's dsp is broken in sox; 
	# disabling it for now.  Note that even when this is fixed,
	# then we should check for USE=alsa and set --without-alsa-dsp
	# appropriately.
	econf --enable-fast-ulaw --enable-fast-alaw --without-alsa-dsp || die
	emake || die
}

src_install () {
	into /usr
	dobin sox play soxeffect
	doman sox.1 soxexam.1
	dodoc Changelog Copyright README TODO *.txt
}

pkg_postinst () {
	# the rec binary doesnt exist anymore
	if([ ! -e /usr/bin/rec ]) then
		ln -s /usr/bin/play /usr/bin/rec 
	fi
}
