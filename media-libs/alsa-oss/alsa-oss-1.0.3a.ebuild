# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/alsa-oss/alsa-oss-1.0.3a.ebuild,v 1.6 2004/07/01 07:54:35 eradicator Exp $

DESCRIPTION="Advanced Linux Sound Architecture OSS compatibility layer."
HOMEPAGE="http://www.alsa-project.org/"
LICENSE="GPL-2"

DEPEND="virtual/libc
	>=media-libs/alsa-lib-1.0"

SLOT="0"
KEYWORDS="x86 -sparc ~ppc ~amd64"

IUSE=""

MY_P=${P/_rc/rc}
SRC_URI="mirror://alsaproject/oss-lib/${P}.tar.bz2"
RESTRICT="nomirror"
S=${WORKDIR}/${MY_P}

src_install() {
	einstall || die
	dodoc COPYING
}
