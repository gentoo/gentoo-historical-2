# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/alsa-xmms/alsa-xmms-0.9.12.ebuild,v 1.3 2003/09/11 01:19:38 msterret Exp $

DESCRIPTION="XMMS output plugin for ALSA 0.9*.  Supports surround 4.0 output with conversion."
HOMEPAGE="http://savannah.gnu.org/download/alsa-xmms/"

LICENSE="GPL-2"
DEPEND=">=media-sound/xmms-1.2.4
	>=media-libs/alsa-lib-0.9.2
	virtual/alsa"

KEYWORDS="x86 ~ppc"

SLOT="0"
SRC_URI="http://savannah.gnu.org/download/${PN}/${P}.tar.gz"
S=${WORKDIR}/${P}

src_install() {
	einstall \
		libdir=${D}/usr/lib/xmms/Output || die

	dodoc AUTHORS README NEWS COPYING ChangeLog
}
