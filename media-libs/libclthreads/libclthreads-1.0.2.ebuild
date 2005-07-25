# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libclthreads/libclthreads-1.0.2.ebuild,v 1.3 2005/07/25 12:41:22 dholm Exp $

IUSE=""

inherit eutils

S="${WORKDIR}/clthreads-${PV}"

DESCRIPTION="An audio library by Fons Adriaensen <fons.adriaensen@skynet.be>"
HOMEPAGE="http://users.skynet.be/solaris/linuxaudio"
SRC_URI="http://users.skynet.be/solaris/linuxaudio/downloads/clthreads-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

DEPEND="virtual/libc"

src_compile() {
	epatch "${FILESDIR}/${P}-makefile.patch"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
