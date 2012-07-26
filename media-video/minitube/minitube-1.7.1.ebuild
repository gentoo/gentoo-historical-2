# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/minitube/minitube-1.7.1.ebuild,v 1.4 2012/07/26 09:01:10 yngwin Exp $

EAPI=4
PLOCALES="ar ca ca_ES da de_DE el en_US es es_AR es_ES fi fi_FI fr gl he_IL hr
hu ia id id_ID it jv ka_GE nb nl nn pl pl_PL pt pt_BR ro ru sk sl sq sr sv_SE
te tr uk_UA zh_CN"

inherit l10n qt4-r2

DESCRIPTION="Qt4 YouTube Client"
HOMEPAGE="http://flavio.tordini.org/minitube"
SRC_URI="http://flavio.tordini.org/files/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug gstreamer kde"

DEPEND=">=x11-libs/qt-gui-4.6:4[accessibility]
	>=x11-libs/qt-dbus-4.6:4
	kde? ( || ( media-libs/phonon[gstreamer?] >=x11-libs/qt-phonon-4.6:4 ) )
	!kde? ( || ( >=x11-libs/qt-phonon-4.6:4 media-libs/phonon[gstreamer?] ) )
	gstreamer? (
		media-plugins/gst-plugins-soup
		media-plugins/gst-plugins-ffmpeg
		media-plugins/gst-plugins-faac
		media-plugins/gst-plugins-faad
	)
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

DOCS="AUTHORS CHANGES TODO"

src_prepare() {
	qt4-r2_src_prepare

	# Remove unneeded translations
	local trans=
	trans=$(l10n_get_locales)
	if [[ -n ${trans} ]]; then
		sed -i -e "/^TRANSLATIONS/s/+=.*/+=${trans}/" locale/locale.pri || die
	fi
}

src_install() {
	qt4-r2_src_install
	newicon images/app.png minitube.png
}
