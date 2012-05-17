# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gigolo/gigolo-0.4.1.ebuild,v 1.7 2012/05/17 18:01:53 ssuominen Exp $

EAPI=4
EAUTORECONF=yes
EINTLTOOLIZE=yes
inherit xfconf

DESCRIPTION="a frontend to easily manage connections to remote filesystems using GIO/GVfs"
HOMEPAGE="http://www.uvena.de/gigolo/ http://goodies.xfce.org/projects/applications/gigolo"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.12:2
	>=dev-libs/glib-2.16"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog NEWS README TODO )
}

src_install() {
	xfconf_src_install
	rm -rf "${ED}"/usr/share/doc/${PN}
}
