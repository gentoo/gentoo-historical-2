# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gtkam/gtkam-0.1.11.ebuild,v 1.7 2004/06/24 22:41:41 agriffis Exp $

inherit eutils gnome2

IUSE="nls gnome jpeg"

S=${WORKDIR}/${P}
DESCRIPTION="A frontend for gPhoto 2"
HOMEPAGE="http://gphoto.org/proj/gtkam"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"

RDEPEND=">=x11-libs/gtk+-2
	>=media-libs/libgphoto2-2.1.4
	jpeg? ( media-libs/libexif-gtk
		media-libs/libexif )"
	# commenting per bug #36684
	#gnome? ( >=gnome-base/libbonobo-2
	#	>=gnome-base/libgnomeui-2 )

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-0.1.10-norpm.patch
	epatch ${FILESDIR}/${P}-gtk24.patch
}

src_compile() {

	local myconf

	myconf="--with-rpmbuild=/bin/false --without-gimp"

	use jpeg \
		&& myconf="${myconf} --with-exif" \
		|| myconf="${myconf} --without-exif"

	#use gnome \
	#	&& myconf="${myconf} --with-gnome --with-bonobo" \
	#	|| myconf="${myconf} --without-gnome --without-bonobo"

	econf ${myconf} `use_enable nls` || die
	emake || die
}

src_install() {
	einstall || die
	rm -rf ${D}/usr/share/doc/gtkam
	dodoc ABOUT-NLS AUTHORS COPYING INSTALL MANUAL NEWS README
}
