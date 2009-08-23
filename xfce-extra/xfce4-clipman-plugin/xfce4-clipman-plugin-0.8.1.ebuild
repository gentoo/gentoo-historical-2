# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-clipman-plugin/xfce4-clipman-plugin-0.8.1.ebuild,v 1.1 2009/08/23 16:35:03 ssuominen Exp $

EAPI=2
inherit xfconf

DESCRIPTION="a simple cliboard history manager for Xfce4 Panel"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2.14:2
	>=gnome-base/libglade-2.6:2.0
	>=x11-libs/gtk+-2.10:2
	>=xfce-base/libxfce4util-4.4
	>=xfce-base/libxfcegui4-4.4
	>=xfce-base/xfce4-panel-4.4
	>=xfce-base/xfconf-4.6
	>=xfce-extra/exo-0.3"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	dev-util/pkgconfig"
