# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qjackctl/qjackctl-0.1.3.ebuild,v 1.4 2004/06/25 00:18:22 agriffis Exp $ 

IUSE=""

DESCRIPTION="A Qt application to control the JACK Audio Connection Kit"
HOMEPAGE="http://qjackctl.sf.net/"
SRC_URI="mirror://sourceforge/qjackctl/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="virtual/glibc
	>=x11-libs/qt-3.1.1
	jack? ( media-sound/jack-audio-connection-kit )"

src_install () {
	einstall || die "make install failed"
}
