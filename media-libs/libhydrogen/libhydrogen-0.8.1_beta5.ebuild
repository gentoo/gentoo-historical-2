# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libhydrogen/libhydrogen-0.8.1_beta5.ebuild,v 1.3 2004/01/30 05:58:33 drobbins Exp $

inherit libtool

MY_P=${P/_/}
DESCRIPTION="Linux Drum Machine - Libary"
HOMEPAGE="http://hydrogen.sourceforge.net/"
SRC_URI="mirror://sourceforge/hydrogen/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND="virtual/x11 \
	>=media-libs/audiofile-0.2.3 \
	alsa? ( media-libs/alsa-lib ) \
	virtual/jack"

DEPEND="$RDEPEND >=sys-devel/autoconf-2.58"

S=${WORKDIR}/${MY_P}

src_compile() {
	einfo "Reconfiguring..."
	export WANT_AUTOCONF=2.5
	aclocal
	autoconf
	automake

	elibtoolize

	econf
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS ChangeLog FAQ README TODO
}
