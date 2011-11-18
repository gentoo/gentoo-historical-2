# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gmtk/gmtk-1.0.5_beta1.ebuild,v 1.1 2011/11/18 14:33:39 ssuominen Exp $

EAPI=4
inherit flag-o-matic toolchain-funcs

MY_P=${PN}-${PV/_beta/b}

DESCRIPTION="GTK+ widget and function libraries for gnome-mplayer"
HOMEPAGE="http://code.google.com/p/gmtk/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
IUSE="alsa dconf +keystore pulseaudio"

COMMON_DEPEND=">=dev-libs/glib-2.26
	x11-libs/gtk+:3
	x11-libs/libX11
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )"
RDEPEND="${COMMON_DEPEND}
	dconf? ( gnome-base/dconf )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext"

REQUIRED_USE="|| ( dconf keystore )"

DOCS=( ChangeLog )

S=${WORKDIR}/${MY_P}

src_configure() {
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags gtk+-3.0)"

	econf \
		--disable-static \
		--enable-gtk3 \
		$(use_enable dconf gsettings) \
		--disable-gconf \
		$(use_enable keystore) \
		--with-gio \
		$(use_with alsa) \
		$(use_with pulseaudio)
}

src_install() {
	default

	rm -rf \
		"${ED}"usr/share/doc/${PN} \
		"${ED}"usr/lib*/*.la
}
