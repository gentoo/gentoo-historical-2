# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kompose/kompose-0.5.1.ebuild,v 1.3 2005/01/21 17:15:42 carlo Exp $

inherit kde

DESCRIPTION="A KDE fullscreen task manager."
HOMEPAGE="http://kompose.berlios.de"
SRC_URI="http://download.berlios.de/kompose/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~amd64 ~sparc"
IUSE=""

DEPEND="media-libs/imlib2"
RDEPEND="media-libs/imlib2"
need-kde 3.2
