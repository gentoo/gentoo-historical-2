# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/eq-audacious/eq-audacious-0.21.ebuild,v 1.1 2007/02/27 15:10:40 beandog Exp $

DESCRIPTION="31-band equalizer for Audacious"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI="http://audacious-media-player.org/~nenolod/audacious/plugins/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug mmx sse sse2"
DEPEND="dev-util/pkgconfig
	>=media-sound/audacious-1.3.0_rc1"

pkg_config() {
	econf $(use_enable debug)
		$(use_enable mmx)
		$(use_enable sse)
		$(use_enable sse2) || die "econf died"
}

src_install() {
	make DESTDIR="${D}" libdir=`pkg-config audacious --variable=effect_plugin_dir` install || make install died
	dodoc AUTHORS BUGS ChangeLog NEWS README README.BSD SKINS TODO
}
