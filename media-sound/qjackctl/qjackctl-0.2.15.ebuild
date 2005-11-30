# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qjackctl/qjackctl-0.2.15.ebuild,v 1.1 2005/02/07 01:24:36 jnc Exp $

IUSE=""

inherit eutils kde-functions

need-qt 3

DESCRIPTION="A Qt application to control the JACK Audio Connection Kit and ALSA sequencer connections."
HOMEPAGE="http://qjackctl.sf.net/"
SRC_URI="mirror://sourceforge/qjackctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="virtual/libc
	media-libs/alsa-lib
	>=x11-libs/qt-3.1.1
	media-sound/jack-audio-connection-kit"

src_install() {
	make prefix="${D}/usr" DESTDIR="${D}" install || die "make install failed"
}
