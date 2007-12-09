# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/jwm/jwm-2.0.1.ebuild,v 1.1 2007/12/09 17:59:21 coldwind Exp $

inherit autotools eutils

IUSE="bidi debug jpeg png truetype xinerama xpm"

DESCRIPTION="Very fast and lightweight still powerfull window manager for X"
SRC_URI="http://joewing.net/programs/jwm/releases/${P}.tar.bz2"
HOMEPAGE="http://joewing.net/programs/jwm/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"

RDEPEND="xpm? ( x11-libs/libXpm )
	xinerama? ( x11-libs/libXinerama )
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXau
	x11-libs/libXdmcp
	truetype? ( virtual/xft )
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	bidi? ( dev-libs/fribidi )
	dev-libs/expat"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	xinerama? ( x11-proto/xineramaproto )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-nostrip.patch
}

src_compile() {
	econf \
		$(use_enable debug) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable truetype xft) \
		$(use_enable xinerama) \
		$(use_enable xpm) \
		$(use_enable bidi fribidi) \
		--enable-shape --enable-xrender || die "configure failed"

	emake || die "emake failed"
}

src_install() {
	dodir /usr/bin
	dodir /etc
	dodir /usr/share/man
	emake BINDIR="${D}/usr/bin" SYSCONF="${D}/etc" \
		MANDIR="${D}/usr/share/man" install || die "emake install failed"
	rm "${D}/etc/system.jwmrc"

	echo "#!/bin/sh" > jwm
	echo "exec /usr/bin/jwm" >> jwm
	exeinto /etc/X11/Sessions
	doexe jwm

	dodoc README example.jwmrc todo.txt
}

pkg_postrm() {
	einfo "Put an appropriate configuration file in /etc/system.jwmrc"
	einfo "or in ~/.jwmrc."
	einfo "An example file can be found in ${R}/usr/share/doc/${P}/"
}
