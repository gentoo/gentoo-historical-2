# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfdesktop/xfdesktop-4.6.1.ebuild,v 1.10 2009/08/02 09:49:31 ssuominen Exp $

EAPI=2
inherit xfconf

DESCRIPTION="Desktop manager for Xfce4"
HOMEPAGE="http://www.xfce.org/projects/xfdesktop"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="debug doc +file-icons +menu-plugin"

LINGUAS="be ca cs da de el es et eu fi fr he hu it ja ko nb_NO nl pa pl pt_BR ro ru sk sv tr uk vi zh_CN zh_TW"

for X in ${LINGUAS}; do
	IUSE="${IUSE} linguas_${X}"
done

RDEPEND="gnome-base/libglade
	x11-libs/libX11
	x11-libs/libSM
	>=x11-libs/libwnck-2.12
	>=dev-libs/glib-2.10:2
	>=x11-libs/gtk+-2.10:2
	>=xfce-base/libxfce4util-4.6
	>=xfce-base/libxfcegui4-4.6
	>=xfce-base/libxfce4menu-4.6
	>=xfce-base/xfconf-4.6
	file-icons? ( >=xfce-base/thunar-1
		>=xfce-extra/exo-0.3.100
		dev-libs/dbus-glib )
	menu-plugin? ( >=xfce-base/xfce4-panel-4.6 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	dev-util/pkgconfig
	doc? ( dev-libs/libxslt )"

pkg_setup() {
	XFCE_LOCALIZED_CONFIGS="/etc/xdg/xfce4/desktop/menu.xml
		/etc/xdg/xfce4/desktop/xfce-registered-categories.xml"
	XFCONF="--disable-dependency-tracking
		$(use_enable file-icons)
		$(use_enable file-icons thunarx)
		$(use_enable file-icons exo)
		$(use_enable menu-plugin panel-plugin)
		$(use_enable doc xsltproc)
		$(use_enable debug)"
	DOCS="AUTHORS ChangeLog NEWS TODO README"
}

src_install() {
	xfconf_src_install

	local config lang
	for config in ${XFCE_LOCALIZED_CONFIGS}; do
		for lang in ${LINGUAS}; do
			local localized_config="${D}/${config}.${lang}"
			if [[ -f ${localized_config} ]]; then
				use "linguas_${lang}" || rm ${localized_config}
			fi
		done
	done
}
