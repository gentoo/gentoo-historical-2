# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-vfs-extras/gnome-vfs-extras-0.99.10.ebuild,v 1.2 2003/07/12 16:12:09 aliz Exp $

inherit gnome2

IUSE=""
S=${WORKDIR}/${P}
DESCRIPTION="the Gnome Virtual Filesystem extra libraries"
HOMEPAGE="http://www.gnome.org/"

SLOT="1"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc ~ppc"

RDEPEND=">=gnome-base/gnome-vfs-2.1.5"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.20
	>=dev-util/pkgconfig-0.12.0
	>=sys-devel/autoconf-2.52"

src_unpack() {
	unpack ${A} || die "unpack failed"

	cd ${S}/samba
	export WANT_AUTOCONF_2_5=1
	autoconf --force
}
	
DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS  README"
