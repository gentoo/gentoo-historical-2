# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/k3b/k3b-0.12.10.ebuild,v 1.2 2006/02/02 19:44:16 corsair Exp $

inherit kde eutils

DESCRIPTION="K3b, KDE CD Writing Software"
HOMEPAGE="http://www.k3b.org/"
SRC_URI="mirror://sourceforge/k3b/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa css dvdr encode ffmpeg flac hal kde mp3 musepack musicbrainz sndfile vcd vorbis"

DEPEND="kde? ( || ( kde-base/kdesu kde-base/kdebase ) )
	hal? ( sys-apps/dbus sys-apps/hal )
	media-libs/libsamplerate
	media-libs/taglib
	>=media-sound/cdparanoia-3.9.8
	sndfile? ( media-libs/libsndfile )
	ffmpeg? ( media-video/ffmpeg )
	flac? ( media-libs/flac )
	mp3? ( media-libs/libmad )
	musepack? ( media-libs/libmpcdec )
	vorbis? ( media-libs/libvorbis )
	musicbrainz? ( media-libs/musicbrainz )
	encode? ( media-sound/lame )
	alsa? ( media-libs/alsa-lib )"

RDEPEND="${DEPEND}
	virtual/cdrtools
	>=app-cdr/cdrdao-1.1.7-r3
	media-sound/normalize
	dvdr? ( app-cdr/dvd+rw-tools )
	css? ( media-libs/libdvdcss )
	encode? ( media-sound/sox
	          media-video/transcode )
	vcd? ( media-video/vcdimager )"

DEPEND="${DEPEND}
	dev-util/pkgconfig"

need-kde 3.3

I18N="${PN}-i18n-${PV}"

# Supported languages and translated documentation for 0.12.8
LANGS="bg br bs ca cs cy da de el en_GB es et fr ga \
	he hi hu is it lt mk nb nl nn pa pl pt pt_BR \
	ro ru sl sr sr@Latn sv ta tr uk zh_CN"

for X in ${LANGS}; do
	SRC_URI="${SRC_URI} linguas_${X}? ( mirror://sourceforge/k3b/${I18N}.tar.bz2 )"
done

pkg_setup() {
	if use hal && ! built_with_use sys-apps/dbus qt; then
		eerror "You are trying to compile ${CATEGORY}/${PF} with the \"hal\" USE flag enabled,"
		eerror "but sys-apps/dbus is not built with Qt support."
		die
	fi

	kde_pkg_setup
}

src_unpack() {
	kde_src_unpack

	local MAKE_LANGS
	for X in ${LANGS}; do
		use linguas_${X} && MAKE_LANGS="${MAKE_LANGS} ${X}"
	done

	if [ -d "${WORKDIR}/${I18N}" ]; then
		cd "${WORKDIR}/${I18N}"
		sed -i -e "s,^SUBDIRS = .*,SUBDIRS = ${MAKE_LANGS}," Makefile.in
	fi
}

src_compile() {
	local myconf="--enable-libsuffix= \
			--with-external-libsamplerate	\
			--without-resmgr		\
			$(use_with kde k3bsetup)	\
			$(use_with hal)			\
			$(use_with encode lame)		\
			$(use_with ffmpeg)		\
			$(use_with flac)		\
			$(use_with vorbis oggvorbis)	\
			$(use_with sndfile)		\
			$(use_with mp3 libmad)		\
			$(use_with musepack)		\
			$(use_with musicbrainz)		\
			$(use_with alsa)"

	# Build process of K3b
	kde_src_compile

	# Build process of K3b-i18n
	local _S=${S}
	if [ -d "${WORKDIR}/${I18N}" ]; then
		S="${WORKDIR}/${I18N}"
		cd "${S}"
		kde_src_compile
	fi
	S=${_S}
}

src_install() {
	kde_src_install
	dodoc FAQ KNOWNBUGS PERMISSIONS

	local _S=${S}
	if [ -d "${WORKDIR}/${I18N}" ]; then
		S="${WORKDIR}/${I18N}"
		cd "${S}"
		kde_src_install
	fi
	S=${_S}

	# Move menu entry
	if use kde; then
		mv ${D}/usr/share/applnk/Settings/System/k3bsetup2.desktop ${D}/usr/share/applications/kde/
	fi
	rm -fR ${D}/usr/share/applnk/
}

pkg_postinst() {
	echo
	einfo "Make sure you have proper read/write permissions on the cdrom device(s)."
	einfo "Usually, it is sufficient to be in the cdrom group."
	echo
}
