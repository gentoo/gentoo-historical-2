# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gmpc/gmpc-0.11.1.ebuild,v 1.1 2004/07/23 20:17:44 axxo Exp $
#
inherit gnome2

DESCRIPTION="A Gnome client for the Music Player Daemon."
HOMEPAGE="http://gmpc.qballcow.nl/"
SRC_URI="http://download.qballcow.nl/programs/${PN}/${P}.tar.gz"
KEYWORDS="~x86 ~amd64 ~ppc"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.4
		>=gnome-base/libglade-2.3
		>=gnome-base/gnome-vfs-2.6"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"

