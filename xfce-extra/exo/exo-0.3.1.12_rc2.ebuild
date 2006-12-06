# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/exo/exo-0.3.1.12_rc2.ebuild,v 1.2 2006/12/06 00:51:40 nichoj Exp $

inherit xfce44 versionator

xfce44_beta

MY_PV="$(replace_version_separator 4 '')"
S="${WORKDIR}/${PN}-${MY_PV}"

DESCRIPTION="Libraries for Xfce 4"
HOMEPAGE="http://www.xfce.org"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=dev-libs/glib-2.6.4
	>=x11-libs/gtk+-2.6
	media-libs/libpng
	x11-libs/pango
	dev-perl/URI
	>=xfce-base/libxfce4mcs-4.3.99.2
	>=xfce-base/libxfce4util-4.3.99.2
	>=xfce-base/libxfcegui4-4.3.99.2"
DEPEND="${RDEPEND}
	dev-python/pygtk
	>=xfce-base/xfce-mcs-manager-4.3.99.2"
