# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ecasound/ecasound-2.6.0.ebuild,v 1.2 2009/05/21 14:35:41 ssuominen Exp $

EAPI=2

inherit eutils multilib python

DESCRIPTION="a package for multitrack audio processing"
HOMEPAGE="http://ecasound.seul.org/ecasound"
SRC_URI="http://${PN}.seul.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="alsa audiofile debug doc jack libsamplerate mikmod ncurses vorbis oss python ruby sndfile"

DEPEND="python? ( dev-lang/python )
	jack? ( media-sound/jack-audio-connection-kit )
	media-libs/ladspa-sdk
	audiofile? ( media-libs/audiofile )
	alsa? ( media-libs/alsa-lib[midi] )
	vorbis? ( media-libs/libvorbis )
	libsamplerate? ( media-libs/libsamplerate )
	mikmod? ( media-libs/libmikmod )
	ruby? ( dev-lang/ruby )
	python? ( dev-lang/python )
	ncurses? ( sys-libs/ncurses )
	sndfile? ( media-libs/libsndfile )
	sys-libs/readline"

src_configure() {
	local PYConf

	if use python; then
		python_version
		PYConf="--enable-pyecasound=c
			--with-python-includes=/usr/include/python${PYVER}
			--with-python-modules=/usr/$(get_libdir)/python${PYVER}"
	else
		PYConf="$myconf --disable-pyecasound"
	fi

	econf \
		$(use_enable alsa) \
		--disable-arts \
		$(use_enable audiofile) \
		$(use_enable debug) \
		$(use_enable jack) \
		$(use_enable libsamplerate) \
		$(use_enable ncurses) \
		$(use_enable oss) \
		$(use_enable ruby rubyecasound) \
		$(use_enable sndfile) \
		--enable-shared \
		--with-largefile \
		--enable-sys-readline \
		${PYConf} || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc BUGS NEWS README TODO Documentation/*.txt
	use doc && dohtml Documentation/*.html
}

pkg_postinst() {
	if use python; then
		ebegin "Byte-compiling ${CATEGORY}/${PF} python modules"
		python_version
		local PYMODULE
		for PYMODULE in ecacontrol.py pyeca.py eci.py; do
			python_mod_compile /usr/$(get_libdir)/python${PYVER}/site-packages/${PYMODULE}
		done
		eend $?
	fi
}

pkg_postrm() {
	python_mod_cleanup
}
