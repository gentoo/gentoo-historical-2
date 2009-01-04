# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/k9copy/k9copy-2.1.0.ebuild,v 1.3 2009/01/04 15:37:25 scarabeus Exp $

EAPI="2"

NEED_KDE="4.1"
KDE_LINGUAS="ca cs de el es_AR es et fr it nl pl pt_BR ru sr sr@Latn tr zh_TW"
inherit kde4-base

DESCRIPTION="k9copy is a DVD backup utility which allows the copy of one or more titles from a DVD9 to a DVD5."
HOMEPAGE="http://k9copy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-Source.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libdvdread
	media-libs/xine-lib
	>=media-video/ffmpeg-0.4.9_p20081014
	x11-libs/qt-dbus:4
	!kdeprefix? ( !app-cdr/k9copy:0 )"

RDEPEND="${DEPEND}
	media-video/dvdauthor
	media-video/mplayer"

S="${WORKDIR}/${P}-Source"

src_unpack() {
	# NOTE: Should be changed once the eclass moving linguas stuff to src_prepare
	# hits the tree or package gets fixed upstream.
	kde4-base_src_unpack

	sed -i -e 's/sr@latin/sr@Latn/g' \
		"${S}"/po/cmake_install.cmake || die "sed failed"
	mv -i "${S}"/po/sr@latin.po "${S}"/po/sr@Latn.po

	enable_selected_linguas
}

pkg_postinst() {
	echo
	elog "If you want K3b burning support in ${P}, please install app-cdr/k3b separately."
	elog "If you want phonon media playback in ${P}, please install media-sound/phonon separately."
	echo
}
