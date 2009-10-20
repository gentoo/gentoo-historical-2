# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/thunar-vcs-plugin/thunar-vcs-plugin-0.1.0.ebuild,v 1.4 2009/10/20 23:21:26 fauli Exp $

EAPI=2
inherit xfconf

DESCRIPTION="adds Subversion actions to the context menu of thunar"
HOMEPAGE="http://goodies.xfce.org/projects/thunar-plugins/thunar-vcs-plugin"
SRC_URI="mirror://xfce/src/thunar-plugins/${PN}/0.1/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug git subversion"

RDEPEND=">=xfce-base/thunar-0.4
	>=x11-libs/gtk+-2.6:2
	>=dev-libs/glib-2.6:2
	git? ( dev-util/git )
	subversion? ( >=dev-libs/apr-0.9.7
		>=dev-util/subversion-1.5 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	XFCONF="--disable-dependency-tracking
		$(use_enable subversion)
		$(use_enable git)
		$(use_enable debug)"
}
