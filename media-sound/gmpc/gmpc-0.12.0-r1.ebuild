# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gmpc/gmpc-0.12.0-r1.ebuild,v 1.11 2006/10/28 01:36:45 flameeyes Exp $

IUSE="gnome"

DESCRIPTION="A Gnome client for the Music Player Daemon."
HOMEPAGE="http://cms.qballcow.nl/index.php?page=Gnome_Music_Player_Client"
SRC_URI="http://download.qballcow.nl/programs/${PN}/${P}.tar.gz"

KEYWORDS="amd64 ppc sparc x86"
SLOT="0"
LICENSE="GPL-2"

RDEPEND=">=x11-libs/gtk+-2.4
	>=gnome-base/libglade-2.3
	gnome? ( >=gnome-base/gnome-vfs-2.6 )
	dev-perl/XML-Parser
	=media-libs/libmpd-0.01"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf $(use_enable gnome gnome-vfs) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
}

DOCS="AUTHORS ChangeLog NEWS README"

