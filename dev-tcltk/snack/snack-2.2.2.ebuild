# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/snack/snack-2.2.2.ebuild,v 1.6 2005/01/01 13:16:20 corsair Exp $

IUSE="alsa oggvorbis"

DESCRIPTION="The Snack Sound Toolkit (Tcl)"
HOMEPAGE="http://www.speech.kth.se/snack/"
SRC_URI="http://www.speech.kth.se/~kare/${PN}${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~x86"
SLOT="0"

DEPEND=">dev-lang/tcl-8.0.5
	>dev-lang/tk-8.0.5
	oggvorbis? ( media-libs/libogg )"

S=${WORKDIR}/${PN}${PV}/unix

src_compile() {
	local myconf="--enable-threads"

	use alsa && myconf="${myconf} --enable-alsa"

	use oggvorbis && myconf="${myconf} --enable-ogg"

	econf ${myconf} || die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D}usr install || die "make install failed"
}
