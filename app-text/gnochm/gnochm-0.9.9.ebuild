# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gnochm/gnochm-0.9.9.ebuild,v 1.2 2007/02/01 15:07:27 beandog Exp $

inherit gnome2

DESCRIPTION="GnoCHM is a CHM file viewer that integrates with the GNOME desktop."

HOMEPAGE="http://gnochm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/pychm-0.8.4
		=dev-python/pygtk-2*
		=dev-python/gnome-python-2*
		=dev-python/gnome-python-extras-2*"
DEPEND="${RDEPEND}
		app-text/scrollkeeper
		>=dev-util/intltool-0.21
		>=dev-lang/python-2.2.1"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="--enable-mime-update=no"
}
