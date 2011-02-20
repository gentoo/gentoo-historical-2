# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/guayadeque/guayadeque-0.2.7.ebuild,v 1.1 2011/02/20 15:24:00 jlec Exp $

EAPI="3"

WX_GTK_VER="2.8"

inherit cmake-utils wxwidgets

DESCRIPTION="Music management program designed for all music enthusiasts"
HOMEPAGE="http://guayadeque.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	media-libs/flac
	media-libs/gstreamer
	media-libs/taglib
	net-misc/curl
	sys-apps/dbus
	x11-libs/wxGTK:2.8[gstreamer]"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig
	dev-util/cmake"

# echo $(cat po/CMakeLists.txt | grep ADD_SUBDIRECTORY | sed 's#ADD_SUBDIRECTORY( \(\w\+\) )#\1#')
LANGS="es uk it de fr is nb th"
for l in ${LANGS}; do
	IUSE="$IUSE linguas_${l}"
done

src_prepare() {
	for l in ${LANGS} ; do
		if use linguas_${l} ; then
			LANGS="${LANGS/${l}/}"
		fi
	done
	llangs=$(echo ${LANGS})
	re="${llangs// /\\|}"
	sed -i -e "/ADD_SUBDIRECTORY( \(${re}\) )/d" po/CMakeLists.txt || die
	base_src_prepare
}
