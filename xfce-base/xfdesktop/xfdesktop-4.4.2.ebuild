# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfdesktop/xfdesktop-4.4.2.ebuild,v 1.3 2007/12/02 20:52:06 drac Exp $

EAPI=1

inherit eutils xfce44

XFCE_VERSION=4.4.2
xfce44
xfce44_core_package

DESCRIPTION="Desktop manager"
HOMEPAGE="http://www.xfce.org/projects/xfdesktop"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="dbus debug doc +menu-plugin"

LANG="be ca cs da de el es et eu fi fr he hu it ja ko nb_NO nl pa pl pt_BR ro ru sk sv tr uk vi zh_CN zh_TW"

RDEPEND="x11-libs/libX11
	x11-libs/libSM
	>=dev-libs/glib-2.6
	>=x11-libs/gtk+-2.6
	gnome-base/librsvg
	>=xfce-base/libxfce4mcs-${XFCE_MASTER_VERSION}
	>=xfce-base/libxfce4util-${XFCE_MASTER_VERSION}
	>=xfce-base/libxfcegui4-${XFCE_MASTER_VERSION}
	>=xfce-base/xfce-mcs-manager-${XFCE_MASTER_VERSION}
	dbus? ( dev-libs/dbus-glib >=xfce-base/thunar-${THUNAR_MASTER_VERSION} )
	menu-plugin? ( >=xfce-base/xfce4-panel-${XFCE_MASTER_VERSION} )
	>=xfce-extra/exo-0.3.2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

for X in ${LANG}; do
	IUSE="${IUSE} linguas_${X}"
done

DOCS="AUTHORS ChangeLog NEWS TODO README"

XFCE_LOCALIZED_CONFIGS="/etc/xdg/xfce4/desktop/xfce-registered-categories.xml
	/etc/xdg/xfce4/desktop/menu.xml"

pkg_setup() {
	XFCE_CONFIG="${XFCE_CONFIG} $(use_enable doc xsltproc) $(use_enable menu-plugin panel-plugin) --enable-exo"

	if use dbus; then
		XFCE_CONFIG="${XFCE_CONFIG} --enable-thunarx --enable-file-icons"
	else
		XFCE_CONFIG="${XFCE_CONFIG} --disable-thunarx --disable-file-icons"
		ewarn "Disabling desktop icons because USE dbus is not selected."
	fi
}

src_install() {
	xfce44_src_install

	# clean out the config files that don't affect us
	local config lang
	for config in ${XFCE_LOCALIZED_CONFIGS}; do
		for lang in ${LANG}; do
			local localized_config="${D}/${config}.${lang}"
			if [[ -f ${localized_config} ]]; then
				use "linguas_${lang}" || rm ${localized_config}
			fi
		done
	done
}

pkg_postinst() {
	xfce44_pkg_postinst
	use dbus || elog "Desktop icons disabled because USE dbus was not selected."
}
