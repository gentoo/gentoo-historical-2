# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/gnome-pilot/gnome-pilot-2.0.9.ebuild,v 1.5 2004/02/22 19:48:30 agriffis Exp $

inherit gnome.org gnome2 eutils

DESCRIPTION="Gnome Pilot apps"
HOMEPAGE="http://www.gnome.org/gnome-pilot/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc"
IUSE=""

RDEPEND=">=gnome-base/libgnome-2.0.0
	>=gnome-base/libgnomeui-2.0.0
	>=gnome-base/libglade-2.0.0
	>=gnome-base/ORBit2-2.6.0
	>=gnome-base/libbonobo-2.0.0
	>=gnome-base/gnome-panel-2.0
	>=gnome-base/gconf-2.0
	>=dev-util/gob-2.0.5
	>=app-pda/pilot-link-0.11.7"

DEPEND="sys-devel/gettext
		>=dev-lang/perl-5.6.0
		${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	# hackaround b0rked with pilot-link detection <liquidx@gentoo.org>
	# epatch ${FILESDIR}/gnome-pilot-2.0.1-pisock.patch
	# USB patch from Mandrake.  Allows gnome-pilot to watch /dev/pilot even
	# when it does not yet exist (because of using devfs).
	# patch -p1 < ${FILESDIR}/gnome-pilot-0.1.70-usb.patch
}

src_compile() {

	local myconf

	myconf="${myconf} --enable-usb"
	myconf="${myconf} --enable-network"
	myconf="${myconf} --enable-pilotlinktest"

	gnome2_src_compile ${myconf}
}

DOCS="AUTHORS COPYING* ChangeLog README NEWS"
SCROLLKEEPER_UPDATE="0"
