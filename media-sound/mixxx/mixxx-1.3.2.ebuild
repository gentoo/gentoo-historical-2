# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mixxx/mixxx-1.3.2.ebuild,v 1.2 2004/10/08 07:18:21 eradicator Exp $

IUSE="jack"

inherit eutils

S="${WORKDIR}/${P}/src"

DESCRIPTION="Digital DJ tool using QT 3.x"
HOMEPAGE="http://mixxx.sourceforge.net"
SRC_URI="mirror://sourceforge/mixxx/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~sparc ~x86"

DEPEND=">=x11-libs/qt-3.1.0
	media-sound/madplay
	media-libs/libogg
	media-libs/libvorbis
	media-libs/audiofile
	media-libs/libsndfile
	media-libs/libsamplerate
	media-libs/portaudio
	jack? ( media-sound/jack-audio-connection-kit )"

RDEPEND="${DEPEND}
	 dev-lang/perl"

DEPEND="${DEPEND}
	sys-apps/sed"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	./configure `use_enable jack Jack` || die "configure failed"

	sed -i -e "s/CFLAGS *= -pipe -w -O2/CFLAGS   = ${CFLAGS} -w/" \
	       -e "s/CXXFLAGS *= -pipe -w -O2/CXXFLAGS   = ${CXXFLAGS} -w/" Makefile

	addpredict  ${QTDIR}/etc/settings
	emake || die "make failed"
}

src_install() {
	make COPY_FILE="cp -fpr" \
	     INSTALL_ROOT="${D}" install || die "make install failed"

	dodoc ../README ../Mixxx-Manual.pdf
}
