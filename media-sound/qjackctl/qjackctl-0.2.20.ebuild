# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qjackctl/qjackctl-0.2.20.ebuild,v 1.1 2006/06/11 20:04:55 eldad Exp $

IUSE=""

inherit eutils kde-functions

DESCRIPTION="A Qt application to control the JACK Audio Connection Kit and ALSA sequencer connections."
HOMEPAGE="http://qjackctl.sf.net/"
SRC_URI="mirror://sourceforge/qjackctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="virtual/libc
	media-libs/alsa-lib
	=x11-libs/qt-3*
	media-sound/jack-audio-connection-kit"

src_install() {
	einstall || die "make install failed"
}
