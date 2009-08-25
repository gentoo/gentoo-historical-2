# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-wavelan-plugin/xfce4-wavelan-plugin-0.5.4.ebuild,v 1.1 2009/08/25 14:05:05 ssuominen Exp $

EAPI=2
inherit xfconf

DESCRIPTION="Wireless monitor panel plugin"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 x86"
IUSE=""

RDEPEND=">=xfce-base/xfce4-panel-4.3.20
	>=xfce-base/libxfce4util-4.3.20
	>=x11-libs/gtk+-2.6:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"
