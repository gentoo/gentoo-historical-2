# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/metacity-python/metacity-python-2.22.0.ebuild,v 1.6 2009/03/08 16:11:38 maekke Exp $

G_PY_PN="gnome-python-desktop"

inherit gnome-python-common

DESCRIPTION="Python bindings for the Metacity window manager"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE=""

SRC_URI="${SRC_URI}
	mirror://gentoo/${G_PY_PN}-${PV}-split.patch.gz"

RDEPEND=">=x11-wm/metacity-2.21.5
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"

src_unpack() {
	gnome-python-common_src_unpack
	cd "${S}"
	epatch "${WORKDIR}/${G_PY_PN}-${PV}-split.patch"
	eautoreconf
}
