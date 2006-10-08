# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-farsight/gst-plugins-farsight-0.10.0.1.ebuild,v 1.2 2006/10/08 18:04:46 blubb Exp $

inherit gst-plugins10

DESCRIPTION="GStreamer plugin for Farsight"
HOMEPAGE="http://projects.collabora.co.uk/darcs/farsight/gst-plugins-farsight"
SRC_URI="http://extindt01.indt.org/VoIP/${P}.tar.gz"

# Create a major/minor combo for SLOT - stolen from gst-plugins-ffmpeg
PVP=(${PV//[-\._]/ })
SLOT=${PVP[0]}.${PVP[1]}

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="jrtplib jpeg2k gsm jingle msn yahoo"

RDEPEND="=media-libs/gstreamer-0.10*
	=media-libs/gst-plugins-base-0.10*
	dev-libs/libxml2
	jrtplib? ( dev-libs/jthread
		>=dev-libs/jrtplib-3.5 )
	jpeg2k? ( media-libs/jasper )
	gsm? ( media-sound/gsm )
	jingle? ( net-libs/libjingle )
	msn? ( media-libs/libmimic )
	yahoo? ( media-libs/libj2k )"

src_compile() {
	# not defined, comment it to avoid compile problems
	sed -i -e "s:GST.*LOCK://\0:" ext/jpeg2000/gstj2kdec.c

	NOCONFIGURE=1 ./autogen.sh
	econf \
		$(use_enable jrtplib) \
		$(use_enable jpeg2k jasper) \
		$(use_enable gsm) \
		$(use_enable jingle jingle-p2p) \
		$(use_enable msn mimic) \
		$(use_with yahoo libj2k) \
		--disable-debug \
		--with-plugins=rtpdemux,rtpjitterbuffer || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
