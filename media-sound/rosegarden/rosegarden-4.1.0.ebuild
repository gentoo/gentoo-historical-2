# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rosegarden/rosegarden-4.1.0.ebuild,v 1.2 2005/03/09 21:49:24 luckyduck Exp $

inherit eutils flag-o-matic

IUSE="alsa arts jack"

MY_PV="${PV/_rc*/}"
MY_PV="${MY_PV/./-}"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="MIDI and audio sequencer and notation editor."
HOMEPAGE="http://www.rosegardenmusic.com/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND=">=kde-base/kdelibs-3.0
	|| ( kde-base/kdemultimedia-meta kde-base/kdemultimedia )
	>=x11-libs/qt-3
	!arts? ( media-libs/alsa-lib )
	alsa? ( media-libs/alsa-lib )
	!alsa? ( arts? ( kde-base/arts ) )
	jack? ( media-sound/jack-audio-connection-kit )
	>=media-libs/ladspa-sdk-1.0
	>=media-libs/ladspa-cmt-1.14"

pkg_setup() {
	snd_conf=""
	if use alsa; then
		if use arts; then
			ewarn "alsa and arts USE flags detected.  Only one can"
			ewarn "used by rosegarden... selecting alsa by default."
		fi
		snd_conf="--without-arts"
	else
		if use arts; then
			snd_conf="--with-arts"
		else
			ewarn "Neither arts or alsa USE flags selected.  Choosing"
			ewarn "alsa by default."
			snd_conf="--without-arts"
		fi
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PV}-dssi.patch
}

src_compile() {
	strip-flags -fvisibility-inlines-hidden

	addwrite ${QTDIR}/etc/settings
	econf ${snd_conf} `use_with jack` \
		--with-ladspa \
		|| die "./configure failed"
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README TODO TRANSLATORS
}
