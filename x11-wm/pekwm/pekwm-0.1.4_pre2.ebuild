# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/pekwm/pekwm-0.1.4_pre2.ebuild,v 1.1 2005/05/22 00:43:16 fserb Exp $

inherit eutils

MYP=${P/_/}
S=${WORKDIR}/${MYP}

IUSE="truetype perl xinerama debug"

DESCRIPTION="A small window mananger based on aewm++"
HOMEPAGE="http://pekwm.org"
SRC_URI="http://pekwm.org/files/${MYP}.tar.bz2
		mirror://gentoo/${PN}-themes.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"

DEPEND="virtual/x11
	truetype? ( virtual/xft )
	perl? ( dev-libs/libpcre )
	media-libs/imlib2"

src_compile() {
	if ! built_with_use media-libs/imlib2 X ; then
		ewarn "you must emerge media-libs/imlib2 with X support to use pekwm"
		ewarn "please USE=\"X\" emerge media-libs/imlib2 before emerging pekwm"
		die "Cannot emerge without X USE flag on imlib2"
	fi

	econf \
		`use_enable truetype xft` \
		`use_enable perl pcre` \
		`use_enable xinerama` \
		`use_enable debug` \
		--enable-menus\
		--enable-harbour\
		--enable-shape\
		--enable-xrandr\
		--enable-imlib2 || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog

	mv ${WORKDIR}/themes/* ${D}/usr/share/${PN}/themes/
}
