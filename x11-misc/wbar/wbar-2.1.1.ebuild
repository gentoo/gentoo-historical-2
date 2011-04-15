# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/wbar/wbar-2.1.1.ebuild,v 1.4 2011/04/15 20:11:55 signals Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="A fast, lightweight quick launch bar."
HOMEPAGE="http://code.google.com/p/wbar/"
SRC_URI="http://wbar.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND="media-libs/imlib2
	x11-libs/libX11
	gtk? ( dev-libs/atk
		dev-libs/glib:2
		dev-libs/libxml2
		gnome-base/libglade
		media-libs/fontconfig
		media-libs/freetype
		media-libs/libpng
		x11-libs/cairo
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	dev-util/intltool"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-warnings.patch\
		"${FILESDIR}"/${P}-opt-config.patch \
		"${FILESDIR}"/${P}-as-needed.patch
	sed -i \
		-e 's^truetype/dustin/PenguinAttack^corefonts/arial^' \
		-e 's^openoffice.png^ooffice.png^' \
		etc/wbar.cfg.in || die "Fixing font in cfg."
	if ! use gtk; then
		# Remove wbar-config from default cfg.
		sed -i -e '5,8d' \
			etc/wbar.cfg.in || die "Removing wbar-config from cfg"
	fi
	sed -i configure.ac -e "/^CPPFLAGS/d" || die #respect flags
	sed -i configure.ac -e "s/-Werror//" || die #Don't -Werror
	eautoreconf
	# Fix build issue reported by xarthisius
	mv "${S}"/src/config/Main.cc "${S}"/src/config/Main-config.cc || die
}

src_configure() {
	econf --bindir=/usr/bin $(use_enable gtk wbar-config)
}
