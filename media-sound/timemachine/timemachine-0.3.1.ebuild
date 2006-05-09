# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/timemachine/timemachine-0.3.1.ebuild,v 1.1 2006/05/09 22:52:43 fvdpol Exp $

IUSE="lash"

inherit flag-o-matic eutils

DESCRIPTION="JACK client record button remembering the last 10 seconds when pressed."
HOMEPAGE="http://plugin.org.uk/timemachine/"
SRC_URI="http://plugin.org.uk/timemachine/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

DEPEND=">=media-sound/jack-audio-connection-kit-0.80.0
	>=x11-libs/gtk+-2.2.4-r1
	>=media-libs/libsndfile-1.0.5
	lash? ( >=media-sound/lash-0.5.0 )"

src_compile() {
	econf `use_enable lash` || die
	make || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog
}
