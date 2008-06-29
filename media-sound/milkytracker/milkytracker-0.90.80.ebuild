# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/milkytracker/milkytracker-0.90.80.ebuild,v 1.3 2008/06/29 11:38:35 drac Exp $

inherit eutils

DESCRIPTION="FastTracker 2 inspired music tracker"
HOMEPAGE="http://www.milkytracker.net/"
SRC_URI="http://www.milkytracker.net/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack"

DEPEND=">=media-libs/libsdl-1.2
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"

src_compile() {
	econf --disable-dependency-tracking \
		$(use_with alsa) \
		$(use_with jack)
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."

	dodoc AUTHORS docs/readme_unix
	dohtml docs/{MilkyTracker,FAQ,ChangeLog}.html

	newicon resources/pictures/carton.png ${PN}.png
	make_desktop_entry ${PN} MilkyTracker ${PN} \
		"AudioVideo;Audio;Sequencer"
}
