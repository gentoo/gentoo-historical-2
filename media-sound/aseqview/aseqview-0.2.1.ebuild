# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/aseqview/aseqview-0.2.1.ebuild,v 1.5 2004/09/14 07:22:46 eradicator Exp $

IUSE=""

DESCRIPTION="ALSA sequencer event viewer/filter."
HOMEPAGE="http://www.alsa-project.org/~iwai/alsa.html"
LICENSE="GPL-2"

DEPEND=">=media-libs/alsa-lib-0.9.0
	x11-libs/gtk+"

SLOT="0"
KEYWORDS="x86 amd64"

SRC_URI="http://www.alsa-project.org/~iwai/${P}.tar.gz"

src_compile() {
	econf || die "./configure failed"
	make clean
	make || die "Make Failed"
}

src_install() {
	einstall || die "Installation Failed"
	dodoc AUTHORS COPYING ChangeLog NEWS README
}
