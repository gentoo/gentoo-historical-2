# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/playmidi/playmidi-2.5-r1.ebuild,v 1.2 2006/01/27 18:40:02 ticho Exp $

IUSE="svga X gtk"

inherit eutils

DESCRIPTION="Command Line and GUI based MIDI Player"
HOMEPAGE="http://sourceforge.net/projects/playmidi/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

RDEPEND="sys-libs/ncurses
	svga? ( media-libs/svgalib )
	gtk? ( =dev-libs/glib-1*
		=x11-libs/gtk+-1* )
	X? ( || ( ( x11-libs/libX11
				x11-libs/libICE
				x11-libs/libXaw )
			virtual/x11 ) )"
DEPEND="${RDEPEND}
	X? ( || ( x11-proto/xextproto virtual/x11 ) )"

S="${WORKDIR}/${P/2.5/2.4}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${P}.patch"
	epatch "${FILESDIR}/CAN-2005-0020.patch"
}

src_compile() {
	local targets="playmidi"
	local LIBGTK=

	use svga && targets="$targets splaymidi"
	use X && targets="$targets xplaymidi"
	if use gtk ; then
		targets="$targets gtkplaymidi"
		CFLAGS="${CFLAGS} $(/usr/bin/gtk-config --cflags)"
		LIBGTK="$(gtk-config --libs)"
	fi

	echo "5" | ./Configure

	emake -j1 CFLAGS="${CFLAGS}" depend clean
	emake LIBGTK="${LIBGTK}" CFLAGS="${CFLAGS}" ${targets} \
		|| die "emake failed"
}

src_install() {
	dobin playmidi || die "dobin failed"
	if use svga ; then
		dobin splaymidi || die "dobin failed (svga)"
	fi
	if use gtk ; then
		dobin gtkplaymidi || die "dobin failed (gtk)"
	fi
	if use X ; then
		dobin xplaymidi || die "dobin failed (X)"
	fi

	dodoc BUGS QuickStart README.1ST

	docinto techref
	dodoc techref/*
}
