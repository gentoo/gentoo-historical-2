# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/terminatorx/terminatorx-3.82.ebuild,v 1.3 2006/01/07 22:44:11 chainsaw Exp $

inherit gnome2

MY_P=${P/terminatorx/terminatorX}
S=${WORKDIR}/${MY_P}
DESCRIPTION='realtime audio synthesizer that allows you to "scratch" on digitally sampled audio data'
HOMEPAGE="http://www.terminatorx.org/"
SRC_URI="http://www.terminatorx.org/dist/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~sparc"
IUSE="3dnow alsa mad vorbis sox"

DEPEND="alsa? ( >=media-libs/alsa-lib-0.9 )
	mad? ( media-sound/madplay )
	vorbis? ( >=media-libs/libvorbis-1.0_beta4 )
	sox? ( media-sound/sox )
	>=x11-libs/gtk+-2.2.0
	>=dev-libs/glib-2.2.0
	virtual/x11
	dev-libs/libxml
	media-libs/audiofile
	media-libs/ladspa-sdk
	media-libs/ladspa-cmt
	app-text/scrollkeeper
	media-libs/liblrdf"

src_unpack() {
	unpack ${A}
	cd ${S}

	# we need the omf fix, or else we get access violation
	# errors related to sandbox
	gnome2_omf_fix ${S}/doc/terminatorX-manual/C/Makefile.in
}

src_compile() {
	econf \
		$(use_enable 3dnow) \
		$(use_enable alsa) \
		$(use_enable mad) \
		$(use_enable vorbis) \
		$(use_enable sox) \
		|| die "econf failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
}
