# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgtkhtml/libgtkhtml-3.0.7.ebuild,v 1.3 2003/08/04 20:05:25 gmsoft Exp $

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
KEYWORDS="x86 ~ppc ~sparc hppa"
IUSE=""

S=${WORKDIR}/${MY_P}

RDEPEND=">=gnome-extra/gal-1.99.8
	>=net-libs/libsoup-1.99.23
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/libgnomeprint-2.2
	>=gnome-base/libgnomeprintui-2.2.1
	>=gnome-base/libbonoboui-2.0
	>=gnome-base/bonobo-activation-2.0
	>=gnome-base/libbonobo-2.0
	>=gnome-base/ORBit2-2.5.6
	>=gnome-base/gnome-vfs-2.1
	>=gnome-base/gail-1.1
	>=dev-libs/libxml2-2.5"
 
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

USE_DESTDIR="1"
SCROLLKEEPER_UPDATE="0"
ELTCONF="--reverse-deps"

src_compile() {
	gnome2_src_configure
	patch ${S}/libtool < ${FILESDIR}/${P}-libtool.patch || die "libtool patch failed"
	emake || die "make failed"
}
