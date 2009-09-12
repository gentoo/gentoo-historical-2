# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gnome-raw-thumbnailer/gnome-raw-thumbnailer-0.99.1.ebuild,v 1.3 2009/09/12 13:06:33 betelgeuse Exp $

EAPI="2"
GCONF_DEBUG=no

inherit autotools eutils gnome2

MY_P=${PN/gnome-}-${PV}

DESCRIPTION="A lightweight and fast raw image thumbnailer for GNOME"
HOMEPAGE="http://libopenraw.freedesktop.org/wiki/RawThumbnailer"
SRC_URI="http://libopenraw.freedesktop.org/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libopenraw[gtk]
	>=x11-libs/gtk+-2
	gnome-base/gnome-vfs"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext
	!media-gfx/raw-thumbnailer"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}"/${P}-drop-libgsf.patch
	eautoreconf
	intltoolize -f || die "intltoolize failed."
}
