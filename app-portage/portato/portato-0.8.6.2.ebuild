# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/portato/portato-0.8.6.2.ebuild,v 1.1 2007/10/23 15:55:11 jokey Exp $

NEED_PYTHON="2.5"
inherit python eutils distutils

DESCRIPTION="A GUI for Portage written in Python."
HOMEPAGE="http://portato.origo.ethz.ch/"
SRC_URI="http://download.origo.ethz.ch/portato/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="kde libnotify nls userpriv"

RDEPEND=">=sys-apps/portage-2.1.2
		>=dev-python/lxml-1.3.2
		>=dev-python/pygtk-2.10.4
		>=x11-libs/vte-0.12.2
		>=gnome-base/libglade-2.5.1
		>=dev-python/pygtksourceview-2.0.0
		!dev-util/portatosourceview

		!userpriv? (
			kde? ( || ( >=kde-base/kdesu-3.5.5 >=kde-base/kdebase-3.5.5	) )
			!kde? ( >=x11-libs/gksu-2.0.0 ) )

		libnotify? ( >=dev-python/notify-python-0.1.1 )
		nls? ( virtual/libintl )"

# only needs gettext as build dependency
# python should be set as DEPEND in the python-eclass
DEPEND="nls? ( sys-devel/gettext )"

S="${WORKDIR}/${PN}"
CONFIG_DIR="etc/${PN}/"
DATA_DIR="usr/share/${PN}/"
LOCALE_DIR="usr/share/locale/"
PLUGIN_DIR="${DATA_DIR}/plugins"
ICON_DIR="${DATA_DIR}/icons"

pkg_setup ()
{
	if ! built_with_use x11-libs/vte python; then
		echo
		eerror "x11-libs/vte has not been built with python support."
		eerror "Please re-emerge vte with the python use-flag enabled."
		die "missing python flag for x11-libs/vte"
	fi
}

src_compile ()
{
	cd "${S}"

	# currently only gtk is supported
	local std="gtk"
	local frontends="[\"$std\"]"

	local su="\"gksu -D 'Portato'\""
	use kde && su="\"kdesu -t --nonewdcop -i %s -c\" % APP_ICON"

	sed -i 	-e "s;^\(VERSION\s*=\s*\).*;\1\"${PV}\";" \
			-e "s;^\(CONFIG_DIR\s*=\s*\).*;\1\"${ROOT}${CONFIG_DIR}\";" \
			-e "s;^\(DATA_DIR\s*=\s*\).*;\1\"${ROOT}${DATA_DIR}\";" \
			-e "s;^\(TEMPLATE_DIR\s*=\s*\).*;\1DATA_DIR;" \
			-e "s;^\(ICON_DIR\s*=\s*\).*;\1\"${ROOT}${ICON_DIR}\";" \
			-e "s;^\(LOCALE_DIR\s*=\s*\).*;\1\"${ROOT}${LOCALE_DIR}\";" \
			-e "s;^\(FRONTENDS\s*=\s*\).*;\1${frontends};" \
			-e "s;^\(STD_FRONTEND\s*=\s*\).*;\1\"${std}\";" \
			-e "s;^\(SU_COMMAND\s*=\s*\).*;\1${su};" \
			-e "s;^\(USE_CATAPULT\s*=\s*\).*;\1False;" \
			"${PN}"/constants.py

	use userpriv &&	sed -i -e "s/Exec=.*/Exec=portato --no-listener/" portato.desktop
	use nls && ./pocompile.sh -emerge

	distutils_src_compile
}

src_install ()
{
	dodir ${DATA_DIR}
	distutils_src_install

	newbin portato.py portato
	dodoc doc/*

	# config
	insinto ${CONFIG_DIR}
	doins etc/*

	# plugins
	insinto ${PLUGIN_DIR}
	keepdir ${PLUGIN_DIR}

	use libnotify && doins plugins/notify.xml

	# desktop
	doicon icons/portato-icon.png
	domenu portato.desktop

	# nls
	use nls && domo i18n/mo/*
}
