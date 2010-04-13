# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/portato/portato-0.13.1-r1.ebuild,v 1.1 2010/04/13 14:02:48 idl0r Exp $

EAPI="2"

inherit python eutils distutils

DESCRIPTION="A GUI for Portage written in Python"
HOMEPAGE="http://necoro.eu/portato"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="kde +libnotify nls userpriv sqlite"
LANGS="ca de es_ES pl pt_BR tr"
for X in $LANGS; do IUSE="${IUSE} linguas_${X}"; done

COMMON_DEPEND="|| (
	dev-lang/python:2.7[sqlite?,threads]
	dev-lang/python:2.6[sqlite?,threads]
	dev-lang/python:2.5[sqlite?,threads] )"

RDEPEND="$COMMON_DEPEND
	app-portage/portage-utils
	x11-libs/vte[python]
	dev-python/pygtksourceview:2
	>=dev-python/pygtk-2.14.0
	dev-python/shm
	>=sys-apps/portage-2.1.6

	!userpriv? (
		kde? ( kde-base/kdesu )
		!kde? ( || ( x11-misc/ktsuss x11-libs/gksu ) )
	)

	libnotify? ( dev-python/notify-python )
	nls? ( virtual/libintl )"

DEPEND="$COMMON_DEPEND
	nls? ( sys-devel/gettext )"

CONFIG_DIR="etc/${PN}"
DATA_DIR="usr/share/${PN}"
LOCALE_DIR="usr/share/locale"
PLUGIN_DIR="${DATA_DIR}/plugins"
ICON_DIR="${DATA_DIR}/icons"
TEMPLATE_DIR="${DATA_DIR}/templates"

pkg_setup()
{
	python_set_active_version 2
}

src_configure ()
{
	sed -i 	-e "s;^\(VERSION\s*=\s*\).*;\1\"${PV}\";" \
			-e "s;^\(CONFIG_DIR\s*=\s*\).*;\1\"${ROOT}${CONFIG_DIR}/\";" \
			-e "s;^\(DATA_DIR\s*=\s*\).*;\1\"${ROOT}${DATA_DIR}/\";" \
			-e "s;^\(TEMPLATE_DIR\s*=\s*\).*;\1\"${ROOT}${TEMPLATE_DIR}/\";" \
			-e "s;^\(ICON_DIR\s*=\s*\).*;\1\"${ROOT}${ICON_DIR}/\";" \
			-e "s;^\(LOCALE_DIR\s*=\s*\).*;\1\"${ROOT}${LOCALE_DIR}/\";" \
			"${PN}"/constants.py || die "sed failed"

	if use userpriv; then
		sed -i -e "s/Exec=.*/Exec=portato --no-fork/" portato.desktop || die "sed failed"
	fi
}

src_compile ()
{
	if use nls; then
		./pocompile.sh -emerge ${LINGUAS} || die "pocompile failed"
	fi

	distutils_src_compile
}

src_install ()
{
	dodir ${DATA_DIR} || die

	distutils_src_install

	python_convert_shebangs 2 portato.py
	newbin portato.py portato || die
	dodoc doc/*

	# config
	insinto ${CONFIG_DIR}
	doins etc/* || die

	# plugins
	insinto ${PLUGIN_DIR}

	# desktop
	doicon icons/portato-icon.png || die
	domenu portato.desktop || die

	# nls
	if use nls && [ -d i18n/mo ]; then
		domo i18n/mo/*
	fi

	# man page
	doman portato.1
}

pkg_postinst ()
{
	distutils_pkg_postinst
	python_mod_optimize "/${PLUGIN_DIR}"
}

pkg_postrm ()
{
	distutils_pkg_postrm
	python_mod_cleanup "/${PLUGIN_DIR}"

	# try to remove the DATA_DIR, as it may still exist
	# reason: it was tried to remove it before plugin stuff was purged
	rmdir "${ROOT}"${DATA_DIR} 2> /dev/null
}
