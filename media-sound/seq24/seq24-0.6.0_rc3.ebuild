# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/seq24/seq24-0.6.0_rc3.ebuild,v 1.2 2005/01/07 20:08:53 chainsaw Exp $

IUSE="jack"
S=${WORKDIR}/${MY_P}
MY_P=${PF/\_/\-}
DESCRIPTION="Seq24 is a loop based MIDI sequencer with focus on live performances."
HOMEPAGE="http://www.filter24.org/seq24/"
SRC_URI="http://www.filter24.org/seq24/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

DEPEND=">=media-libs/alsa-lib-0.9.0
	=dev-cpp/gtkmm-2.2*
	jack? ( media-sound/jack-audio-connection-kit )"

src_compile() {
	econf $(use_enable jack-support) || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README RTC SEQ24
}
