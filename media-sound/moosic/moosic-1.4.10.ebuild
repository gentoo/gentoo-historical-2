# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/moosic/moosic-1.4.10.ebuild,v 1.3 2004/04/01 07:34:40 eradicator Exp $

DESCRIPTION="Moosic is a music player that focuses on easy playlist management"
HOMEPAGE="http://www.nanoo.org/~daniel/moosic/"
SRC_URI="http://www.nanoo.org/~daniel/moosic/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND="virtual/python"

src_install() {
	make install INSTALL_PREFIX=$D/usr

	dodoc ChangeLog History Moosic_Client_API.txt README Todo
}

