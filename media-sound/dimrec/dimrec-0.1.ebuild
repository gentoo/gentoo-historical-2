# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/dimrec/dimrec-0.1.ebuild,v 1.5 2003/02/13 13:09:55 vapier Exp $

IUSE="gtk"

DESCRIPTION="A client/server media player"
SRC_URI="http://bluweb.com/chouser/proj/dimrec/${P}.tar.gz"
HOMEPAGE="http://bluweb.com/chouser/proj/dimrec/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/python
	gtk? ( >=dev-python/pygtk-0.6.9 )
	>=irman-python-0.1"

inherit distutils
