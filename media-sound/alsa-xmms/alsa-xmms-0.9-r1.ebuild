# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-xmms/alsa-xmms-0.9-r1.ebuild,v 1.6 2002/10/19 22:21:54 cselkirk Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Allows XMMS to output on any ALSA 0.9* device. It also supports surround 4.0 output with conversion"
SRC_URI="http://savannah.gnu.org/download/${PN}/${P}.tar.gz"
HOMEPAGE="http://savannah.gnu.org/download/alsa-xmms/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

DEPEND="media-sound/xmms
	>=media-libs/alsa-lib-0.9.0_rc2
	>=media-sound/alsa-driver-0.9.0_rc2
	x11-libs/gtk+"

src_install() {

	einstall \
		libdir=${D}/usr/lib/xmms/Output || die

	dodoc AUTHORS README NEWS
}
