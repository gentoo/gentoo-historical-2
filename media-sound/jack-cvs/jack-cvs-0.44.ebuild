# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jack-cvs/jack-cvs-0.44.ebuild,v 1.2 2003/01/08 00:19:22 raker Exp $

IUSE="doc"

inherit cvs            

DESCRIPTION="A low-latency audio server - cvs version"
HOMEPAGE="http://jackit.sourceforge.net/"

ECVS_SERVER="cvs.jackit.sourceforge.net:/cvsroot/jackit"
ECVS_MODULE="jack"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/ardour" 

SRC_URI=""

# libjack is LGPL, the rest is GPL
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~x86"

DEPEND="dev-libs/glib
	>=media-libs/alsa-lib-0.9.0_rc6
	>=media-libs/libsndfile-1.0.0
	>=x11-libs/fltk-1.1.1
	!media-sound/jack-audio-connection-kit"
PROVIDE="virtual/jack"

S="${WORKDIR}/${PN/-cvs/}"

src_compile() {
	export LDFLAGS="-L/usr/lib/fltk-1.1"                                   	       
	export CPPFLAGS="-I/usr/include/fltk-1.1"
	sh autogen.sh
	econf || die "configure failed"
	emake || die "parallel make failed"
}

src_install() {
	make DESTDIR=${D} install || die
}

pkg_postinst() {

	einfo ""
	einfo "Remember to re-emerge jack-cvs before re-emerging ardour-cvs"
	einfo ""
}
