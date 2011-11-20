# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kcm-gtk-config/kcm-gtk-config-1.5.ebuild,v 1.7 2011/11/20 14:49:39 dilfridge Exp $

EAPI=4

KDE_MINIMAL="4.6"
KDE_LINGUAS_DIR=translations
KDE_LINGUAS="ca cs el es fr gl id it"
MY_P=${P/kcm/chakra}
inherit kde4-base

DESCRIPTION="KCM for set the look&feel of your Gtk apps using the KDE systemsettings."
HOMEPAGE="http://kde-apps.org/content/show.php?content=137496"
SRC_URI="http://chakra-project.org/sources/gtk-integration/${MY_P}.tar.gz"

LICENSE="GPL-3"

KEYWORDS="amd64 ~arm ppc ~ppc64 x86"
SLOT="4"
IUSE=""

COMMON_DEPEND="$(add_kdebase_dep kdelibs)"
DEPEND="${COMMON_DEPEND}
	dev-util/automoc
"
RDEPEND="${COMMON_DEPEND}
	!kde-misc/kcm_gtk
	$(add_kdebase_dep kcmshell)
"

S=${WORKDIR}/${MY_P}

pkg_postinst() {
	kde4-base_pkg_postinst
	einfo
	elog "If you notice missing icons in your GTK applications, you may have to install"
	elog "the corresponding themes for GTK. A good guess would be x11-themes/oxygen-gtk"
	elog "for example."
	einfo
}
