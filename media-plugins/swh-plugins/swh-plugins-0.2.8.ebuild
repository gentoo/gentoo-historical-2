# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/swh-plugins/swh-plugins-0.2.8.ebuild,v 1.6 2003/12/06 23:28:50 lanius Exp $

DESCRIPTION="Cool GPL'd audio plugins/effects for use with ALSA and LADSPA"
HOMEPAGE="http://plugin.org.uk/"
SRC_URI="http://plugin.org.uk/releases/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="dev-libs/fftw"

src_unpack() {
	unpack ${P}.tar.gz

	cd ${S}
	patch -p1 < ${FILESDIR}/${PN}-quickfixes.patch || die

	autoconf
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING README TODO || die
}

pkg_postinst() {
	ewarn "WARNING: You have to be careful when using the"
	ewarn "swh plugins. Be sure to lower your sound volume"
	ewarn "and then play around a bit with the plugins so"
	ewarn "you get a feeling for it. Otherwise your speakers"
	ewarn "won't like that."
}
