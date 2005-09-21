# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/akode/akode-2.0_beta1.ebuild,v 1.1 2005/09/21 17:16:04 greg_g Exp $

MY_P=${P/_beta/b}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A simple framework to decode the most common audio formats."
HOMEPAGE="http://wiki.kde.org/tiki-index.php?page=aKode"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz" # Needs to be changed as soon as akode is moved to developers.kde.org
LICENSE="LGPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa jack flac mp3 oss speex vorbis"

DEPEND="media-libs/libsamplerate
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	flac? ( media-libs/flac )
	mp3? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )
	speex? ( media-libs/speex )"

src_compile() {
	local myconf="--with-libsamplerate
	              $(use_with oss) $(use_with alsa) $(use_with jack)
	              $(use_with flac) $(use_with mp3 libmad)
	              $(use_with vorbis) $(use_with speex)
	              --without-polypaudio"

	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
