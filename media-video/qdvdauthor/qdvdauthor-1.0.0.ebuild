# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/qdvdauthor/qdvdauthor-1.0.0.ebuild,v 1.3 2008/07/27 21:54:04 carlo Exp $

EAPI=1

inherit eutils flag-o-matic qt3

DESCRIPTION="'Q' DVD-Author is a GUI frontend for dvdauthor written in Qt"
HOMEPAGE="http://qdvdauthor.sourceforge.net/"
SRC_URI="mirror://sourceforge/qdvdauthor/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="xine mplayer"

DEPEND=">=media-video/dvdauthor-0.6.11
	>=media-gfx/imagemagick-6.1.8.8
	>=media-video/mjpegtools-1.6.2
	>=media-video/dvd-slideshow-0.7.2
	xine? ( >=media-libs/xine-lib-1.1.0 )
	mplayer? ( media-video/mplayer )
	!xine? ( !mplayer? ( >=media-libs/xine-lib-1.1.0 ) )
	x11-libs/qt:3"

RDEPEND="${DEPEND}
	media-libs/netpbm
	media-video/videotrans
	media-sound/toolame
	media-sound/lame
	media-sound/sox"

# TODO:
# media-video/dvd-slideshow -> optional
# installing further tools -> needs evaluation

src_unpack() {
	unpack ${A}
	cd "${S}"

	# do not over-optimize (see bug #147250)
	replace-flags -O[s3] -O2
	filter-flags -finline-functions

	# set our C(XX)FLAGS
	for PRO in */*.pro */*/*.pro; do
		echo "QMAKE_CFLAGS_RELEASE = ${CFLAGS}" >> "${PRO}"
		echo "QMAKE_CXXFLAGS_RELEASE = ${CXXFLAGS}" >> "${PRO}"
	done

	# full-qualify qmake in configure and append -nocache (see bug #118697)
	sed -i -e "s:make;\?[[:space:]]*\$:make ${MAKEOPTS};:g" \
		-e "s:\(/qmake\):\1 -nocache QMAKE=\$QTDIR/bin/qmake:g" configure

	# fixing defaults from /usr/local/bin to gentoo default /usr/bin
	sed -i -e "s:/usr/local/bin:/usr/bin:g" doc/sound.txt \
		qdvdauthor/dialog*.cpp qdvdauthor/qslideshow/dialog*.cpp
}

src_compile() {
	local myconf="--prefix=/usr --build-qplayer --build-qslideshow"

	# select backend (VLC is currently broken)
	#use vlc && myconf="${myconf} --with-vlc-support"
	use xine && myconf="${myconf} --with-xine-support"
	use mplayer && myconf="${myconf} --with-mplayer-support"

	# if no backend selected, use XINE as default
	if ! use xine && ! use mplayer; then
		myconf="${myconf} --with-xine-support"
	fi

	./configure --qt-dir="${QTDIR}" ${myconf} || die "configure failed"
}

src_install() {
	emake -C qdvdauthor            INSTALL_ROOT="${D}" install || die "qdvdauthor install failed"
	emake -C qdvdauthor/qslideshow INSTALL_ROOT="${D}" install || die "qslideshow install failed"
	emake -C qdvdauthor/qplayer    INSTALL_ROOT="${D}" install || die "qplayer install failed"

	dobin bin/{qdvdauthor,qslideshow,qplayer}
	dodoc CHANGELOG README TODO doc/{ISO*,look*,sound*,todo*,render*}.txt

	domenu qdvdauthor.desktop
	doicon qdvdauthor.png
}
