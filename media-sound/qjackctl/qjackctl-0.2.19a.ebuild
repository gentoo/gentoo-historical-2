# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qjackctl/qjackctl-0.2.19a.ebuild,v 1.3 2006/06/15 18:36:21 dertobi123 Exp $

IUSE=""

inherit eutils kde-functions

DESCRIPTION="A Qt application to control the JACK Audio Connection Kit and ALSA sequencer connections."
HOMEPAGE="http://qjackctl.sf.net/"
SRC_URI="mirror://sourceforge/qjackctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc ~x86"

DEPEND="virtual/libc
	media-libs/alsa-lib
	=x11-libs/qt-3*
	media-sound/jack-audio-connection-kit"

src_install() {
	einstall || die "make install failed"
}
