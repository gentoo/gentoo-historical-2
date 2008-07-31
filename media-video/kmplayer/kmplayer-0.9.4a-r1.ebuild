# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kmplayer/kmplayer-0.9.4a-r1.ebuild,v 1.9 2008/07/31 20:27:20 carlo Exp $

inherit kde eutils

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="KMPlayer is a Video player plugin for Konqueror and basic MPlayer/Xine/ffmpeg/ffserver/VDR frontend for KDE."
HOMEPAGE="http://kmplayer.kde.org/"
SRC_URI="http://kmplayer.kde.org/pkgs/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="mplayer xine cairo"

RDEPEND="mplayer? ( media-video/mplayer )
	xine? ( >=media-libs/xine-lib-1.1.1 )
	cairo? ( x11-libs/cairo )"
DEPEND="x11-libs/libXv
	xine? ( >=media-libs/xine-lib-1.1.1 )
	cairo? ( x11-libs/cairo )"

LANGS="ar br bs ca cs cy da de el en_GB es et fi fr ga gl he hi hu is it ja ka
lt mt nb nl pa pl pt_BR pt ro ru rw sk sr@Latn sr sv ta tr uk zh_CN"

LANGS_DOC="da de en es et fr it nl pt ru sv"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

need-kde 3.5

PATCHES="${FILESDIR}/kmplayer-0.9.4a-vop2vf.patch"

pkg_setup() {
	if ! use mplayer && ! use xine && ! use cairo; then
		echo
		ewarn "Neither the mplayer, xine or cairo use flags have been set."
		ewarn "One of them is required. From them, mplayer can be installed"
		ewarn "afterwards; however and xine will require you to recompile."
	fi
}

src_unpack() {
	kde_src_unpack

	if use mplayer && use amd64 && ! has_version media-video/mplayer; then
		elog 'NOTICE: You have mplayer-bin installed; you will need to configure'
		elog 'NOTICE: kmplayer to use it from within the application.'
	fi

	cd "${WORKDIR}/${MY_P}/po"
	for X in ${LANGS} ; do
		use linguas_${X} || rm -f "${X}."*
	done

	MAKE_DOC=$(echo $(echo "${LINGUAS} ${LANGS_DOC}" | tr ' ' '\n' | sort | uniq -d))
	[[ -n ${MAKE_DOC} ]] && [[ -n ${DOC_DIR_SUFFIX} ]] && MAKE_DOC=$(echo "${MAKE_DOC}" | tr '\n' ' ') && MAKE_DOC="${MAKE_DOC// /${DOC_DIR_SUFFIX} }"
	sed -i -e "s:^SUBDIRS =.*:SUBDIRS = ${MAKE_DOC}:" \
		"${KDE_S}/doc/Makefile.am" || die "sed for locale failed"

	rm -f "${S}/configure"
}

src_compile(){
	local myconf="--without-gstreamer $(use_with xine) $(use_with cairo)"
	kde_src_compile
}

src_install() {
	kde_src_install

	# Remove this, as kdelibs 3.5.4 provides it
	rm -f "${D}/usr/share/mimelnk/application/x-mplayer2.desktop"
}
