# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gnome-jabber/gnome-jabber-0.4.ebuild,v 1.1 2004/04/26 17:16:14 tester Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="Gnome Jabber Client"
SRC_URI="mirror://sourceforge/gnome-jabber/${P}.tar.bz2"
HOMEPAGE="http://gnome-jabber.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc"

DEPEND=">=x11-libs/gtk+-2.0.4
	>=gnome-base/libgnomeui-2.0.0
	>=gnome-base/libglade-2.0.0
	>net-libs/gnet-2
	>=gnome-base/gconf-2.0
	>=dev-libs/libxml2-2.4.23
	sys-devel/gettext"
# the dependency on gnome-panel was wrong in configure.in

DOCS="AUTHORS COPYING ChangeLog README NEWS TODO"

src_compile() {
	mv ${S}/intltool-merge.in ${S}/intltool-merge.in.orig
	# XML parser weirdness
	cat ${S}/intltool-merge.in.orig | sed s/OrigTree/Tree/ > ${S}/intltool-merge.in
	gnome2_src_compile
}
