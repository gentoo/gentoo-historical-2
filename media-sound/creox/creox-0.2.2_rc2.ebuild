# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/creox/creox-0.2.2_rc2.ebuild,v 1.7 2004/07/03 21:41:30 carlo Exp $

inherit kde eutils

MY_P=${P/_/}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="CREOX Real Time Effects Processor"
HOMEPAGE="http://www.uid0.sk/zyzstar/?creox"
SRC_URI="http://www.uid0.sk/zyzstar/projects/creox/downloads/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""

DEPEND="media-sound/jack-audio-connection-kit"
need-kde 3

src_unpack() {
	kde_src_unpack

	cd ${S}
	epatch ${FILESDIR}/${P}-ebusy.patch
}
