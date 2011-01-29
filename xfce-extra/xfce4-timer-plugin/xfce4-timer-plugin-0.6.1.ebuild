# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-timer-plugin/xfce4-timer-plugin-0.6.1.ebuild,v 1.3 2011/01/29 07:21:29 ssuominen Exp $

EAPI=3
inherit xfconf

DESCRIPTION="A simple timer plug-in for the Xfce desktop environment"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-timer-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/0.6/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

RDEPEND=">=xfce-base/xfce4-panel-4.3.20
	>=xfce-base/libxfcegui4-4.2
	>=xfce-base/libxfce4util-4.3"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

pkg_setup() {
	PATCHES=( "${FILESDIR}"/${P}-segfault_with_48_panel.patch )

	XFCONF=(
		--disable-dependency-tracking
		)

	DOCS="AUTHORS ChangeLog README TODO"
}
