# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-hdaps/xfce4-hdaps-0.0.6.ebuild,v 1.1 2010/03/25 19:59:46 ssuominen Exp $

EAPI=2
inherit linux-info xfconf

DESCRIPTION="A plugin to indicate the status of the IBM Hard Drive Active Protection System"
HOMEPAGE="http://michael.orlitzky.com/code/xfce4-hdaps.php"
SRC_URI="http://michael.orlitzky.com/code/releases/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

COMMON_DEPEND=">=x11-libs/gtk+-2.12:2
	>=xfce-base/libxfce4ui-4.7
	>=xfce-base/libxfce4util-4.6
	>=xfce-base/xfce4-panel-4.6"
RDEPEND="${COMMON_DEPEND}
	>=app-laptop/hdapsd-20081213
	>=app-laptop/tp_smapi-0.39"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	XFCONF="--disable-option-checking
		$(use_enable debug)"

	linux-info_pkg_setup

	if kernel_is lt 2 6 28; then
		ewarn
		ewarn "Unsupported kernel detected. Upgrade to 2.6.28 or above."
		ewarn
	fi
}
