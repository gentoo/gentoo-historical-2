# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pd/pd-0.35_pre24.ebuild,v 1.3 2003/02/13 13:17:39 vapier Exp $

# Miller Puckette uses nonstandard versioning scheme that we have to crunch
MY_P=${P/_pre/-test}
S=${WORKDIR}/${MY_P}
DESCRIPTION="real-time music and multimedia environment"
SRC_URI="http://www-crca.ucsd.edu/~msp/Software/${MY_P}.linux.tar.gz"
HOMEPAGE="http://www-crca.ucsd.edu/~msp/software.html"

SLOT="0"
LICENSE="BSD | as-is"
KEYWORDS="x86"

#
# need to do something with alsa here:
# pd can be configured to use alsa-0.5x or alsa-0.9x,
# but i don't know how to determine which one is installed
# automagicly
#
DEPEND=">=dev-lang/tcl-8.3.3
	>=dev-lang/tk-8.3.3"

src_unpack() {
	unpack ${A}
	cd ${S} || die
	patch -p1 < ${FILESDIR}/${MY_P}-gentoo.patch || die
	cd src || die
	autoconf || die
}

src_compile() {

	cd src
	econf || die "./configure failed"
	emake || die
}

src_install () {
	cd src
	make DESTDIR=${D} install || die
}
