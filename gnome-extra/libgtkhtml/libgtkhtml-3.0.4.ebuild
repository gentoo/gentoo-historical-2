# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgtkhtml/libgtkhtml-3.0.4.ebuild,v 1.4 2003/09/12 09:22:50 spider Exp $

inherit gnome2

MY_P=${P/lib/}
MY_PN=${PN/lib/}
DESCRIPTION="Lightweight HTML Rendering/Printing/Editing Engine"
HOMEPAGE="http://www.gnome.org/"

# stolen from gnome.org eclass because it support this one-off name-mangling

[ -z "${GNOME_TARBALL_SUFFIX}" ] && export GNOME_TARBALL_SUFFIX="bz2"
PVP=($(echo " $PV " | sed 's:[-\._]: :g'))
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP[0]}.${PVP[1]}/${MY_P}.tar.${GNOME_TARBALL_SUFFIX}"
LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~x86 ~ppc"
IUSE=""

S=${WORKDIR}/${MY_P}

RDEPEND=">=gnome-base/libgnomeui-2.2
	>=gnome-base/libgnomeprint-2.2
	>=gnome-base/libgnomeprintui-2.2.1
	>=gnome-base/libbonoboui-2.0
	>=gnome-base/libbonobo-2.0
	>=gnome-extra/gal-1.99.6
	>=gnome-base/ORBit2-2.5.6
	>=net-libs/libsoup-1.99.17
	>=dev-libs/libxml2-2.5
	>=gnome-base/gnome-vfs-2.1
	>=gnome-base/gail-1.1"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

USE_DESTDIR="1"
SCROLLKEEPER_UPDATE="0"

# HACK HACK HACK !!!
# libtool's lameness causes libgtkhtml to link to the older installed version
# rather than the one in its own source tree. normally, elibtoolize
# --reverse-deps solves this, but in this case, it screws up when linking
# src/gtest.c
#
# so, i've decided to re-create libgtkhtml-3.0.so.0 symlinks. if anyone
# knows a better solution, please let me know. - <liquidx@gentoo.org>

src_install() {
	gnome2_src_install
	dosym /usr/lib/libgtkhtml-a11y-3.0.so.2 /usr/lib/libgtkhtml-a11y-3.0.so.0
	dosym /usr/lib/libgtkhtml-3.0.so.2 /usr/lib/libgtkhtml-3.0.so.0
	dosym /usr/lib/libgtkhtml-a11y-3.0.so.2 /usr/lib/libgtkhtml-a11y-3.0.so.1
	dosym /usr/lib/libgtkhtml-3.0.so.2 /usr/lib/libgtkhtml-3.0.so.1
}
