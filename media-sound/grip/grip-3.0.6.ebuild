# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/grip/grip-3.0.6.ebuild,v 1.1 2003/02/17 00:19:42 agenkin Exp $

DESCRIPTION="GTK+ based Audio CD Player/Ripper."
HOMEPAGE="http://www.nostatic.org/grip"
LICENSE="GPL-2"

DEPEND="=x11-libs/gtk+-1.2*
	=sys-libs/db-1*
	media-sound/lame
	media-sound/cdparanoia
	media-libs/id3lib
	gnome-base/gnome-libs
	gnome-base/ORBit
	gnome-base/libghttp
	oggvorbis? ( media-sound/vorbis-tools )
	nls? ( sys-devel/gettext )"

IUSE="nls oggvorbis"
SLOT="0"
KEYWORDS="~x86 ~ppc"

SRC_URI="http://www.nostatic.org/grip/${P}.tar.gz"
S=${WORKDIR}/${P}

src_compile() {
	local myconf
	use nls || myconf="--disable-nls"

	econf ${myconf} || die
	emake || die
}

src_install () {
	einstall || die

	dodoc ABOUT-NLS AUTHORS CREDITS COPYING ChangeLog README TODO NEWS
}
