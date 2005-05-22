# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-imms/xmms-imms-2.1.1.ebuild,v 1.2 2005/05/22 13:56:38 luckyduck Exp $

inherit eutils

MY_P=${P/xmms-/}
DESCRIPTION="Intelligent playlist plug-in that tracks your listening patterns
and dynamically adapts to your taste"
HOMEPAGE="http://www.luminal.org/phpwiki/index.php/IMMS"
SRC_URI="mirror://sourceforge/imms/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="bmp xmms"

RESTRICT="primaryuri"

RDEPEND="=dev-db/sqlite-3*
	xmms? ( >=media-sound/xmms-1.2.7 )
	bmp? ( >=media-sound/beep-media-player-0.9.7 )
	>=media-libs/taglib-1.1
	>=dev-libs/libpcre-4.3
	=sci-libs/fftw-3*
	media-sound/sox
	>=dev-libs/glib-2"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.5
	>=sys-apps/sed-4.0.7"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A} && cd ${S}
	epatch ${FILESDIR}/${PV}-xorg.patch
}

src_install () {
	dobin build/immsd || die
	dobin build/immstool || die
	dobin build/analyzer || die

	# install xmms plugin
	if use xmms
	then
		exeinto "$(xmms-config --general-plugin-dir)"
		doexe build/libxmmsimms*.so || die
	fi

	# install bmp plugin
	if use bmp
	then
		exeinto "$(beep-config --general-plugin-dir)"
		doexe build/libbmpimms*.so || die
	fi
	dodoc INSTALL README
}

src_test() { :; }
