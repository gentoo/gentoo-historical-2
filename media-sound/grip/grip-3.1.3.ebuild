# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/grip/grip-3.1.3.ebuild,v 1.1 2003/11/04 21:21:21 mr_bones_ Exp $

inherit eutils

DESCRIPTION="GTK+ based Audio CD Player/Ripper."
HOMEPAGE="http://www.nostatic.org/grip"
SRC_URI="mirror://sourceforge/grip/${P}.tar.gz"
LICENSE="GPL-2"

DEPEND="=x11-libs/gtk+-2.2*
	x11-libs/vte
	=sys-libs/db-1*
	media-sound/lame
	media-sound/cdparanoia
	>=media-libs/id3lib-3.8.3
	>=gnome-base/libgnomeui-2.2.0
	gnome-base/ORBit2
	gnome-base/libghttp
	oggvorbis? ( media-sound/vorbis-tools )
	nls? ( sys-devel/gettext )"

IUSE="nls oggvorbis"
SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~amd64"

src_compile() {
	econf --disable-dependency-tracking `use_enable nls` || die
	emake || die "emake failed"
}

src_install () {
	einstall || die
	dodoc AUTHORS CREDITS ChangeLog README TODO || die "dodoc failed"
}
