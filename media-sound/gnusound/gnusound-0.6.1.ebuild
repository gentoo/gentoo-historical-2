# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gnusound/gnusound-0.6.1.ebuild,v 1.2 2004/03/27 03:35:16 eradicator Exp $

DESCRIPTION="GNUsound is a sound editor for Linux/x86"
HOMEPAGE="http://gnusound.sourceforge.net/"
SRC_URI="http://gnusound.sourceforge.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="libsamplerate"

DEPEND=">=gnome-base/libglade-2.0.1
	gnome-base/gnome-libs
	>=gnome-base/libgnomeui-2.2.0.1
	>=media-libs/audiofile-0.2.3
	libsamplerate? ( media-libs/libsamplerate )"

src_unpack() {
	unpack ${A} || die "unpack failure"
	cd ${S} || die "workdir not found"
	rm -f doc/Makefile || die "could not remove doc Makefile"
	rm -f modules/Makefile || die "could not remove modules Makefile"
	sed -i "s:docrootdir:datadir:" doc/Makefile.in
}

src_compile() {
	econf `use_with libsamplerate` --enable-optimization || die "Configure failure"

	emake || die "Make failure"
}

src_install() {
	einstall || die "make install failure"
	dodoc LICENSE README NOTES TODO CHANGES
}
