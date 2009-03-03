# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/libgtop-python/libgtop-python-2.22.0.ebuild,v 1.3 2009/03/03 20:56:31 ranger Exp $

G_PY_PN="gnome-python-desktop"
G_PY_BINDINGS="gtop"

inherit gnome-python-common

DESCRIPTION="Python bindings for the libgtop library"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

SRC_URI="${SRC_URI}
	mirror://gentoo/${G_PY_PN}-${PV}-split.patch.gz"

RDEPEND=">=gnome-base/libgtop-2.13.0
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"

src_unpack() {
	gnome-python-common_src_unpack
	cd "${S}"
	epatch "${WORKDIR}/${G_PY_PN}-${PV}-split.patch"
	eautoreconf
}
