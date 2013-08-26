# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/fbpanel/fbpanel-6.1-r1.ebuild,v 1.1 2013/08/26 19:07:52 jer Exp $

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="light-weight X11 desktop panel"
HOMEPAGE="http://fbpanel.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( CHANGELOG CREDITS README )

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlinking.patch
	sed -i -e "/libdir/s|/lib|/$(get_libdir)|g" configure || die
	tc-export CC
}

src_configure() {
	# not autotools based
	./configure || die
}

pkg_postinst() {
	elog "For the volume plugin to work, you need to configure your kernel"
	elog "with CONFIG_SND_MIXER_OSS or CONFIG_SOUND_PRIME or some other means"
	elog "that provide the /dev/mixer device node."
}
