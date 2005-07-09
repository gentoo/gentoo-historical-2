# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/swh-plugins/swh-plugins-0.4.3.ebuild,v 1.6 2005/07/09 18:02:30 swegener Exp $

IUSE=""
DESCRIPTION="Cool GPL'd audio plugins/effects for use with ALSA and LADSPA"
HOMEPAGE="http://plugin.org.uk"
SRC_URI="http://plugin.org.uk/releases/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~amd64"

DEPEND="media-libs/ladspa-sdk
	sci-libs/fftw
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A} || die

	cd ${S}
	sed -i '/MACHINE=/s/.*/MACHINE=""/' configure
}
src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING README TODO || die
}

pkg_postinst() {
	ewarn "WARNING: You have to be careful when using the"
	ewarn "swh plugins. Be sure to lower your sound volume"
	ewarn "and then play around a bit with the plugins so"
	ewarn "you get a feeling for it. Otherwise your speakers"
	ewarn "won't like that."
}
