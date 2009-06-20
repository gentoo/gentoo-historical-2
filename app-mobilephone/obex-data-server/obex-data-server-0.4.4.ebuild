# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/obex-data-server/obex-data-server-0.4.4.ebuild,v 1.2 2009/06/20 21:52:06 mrness Exp $

EAPI="2"

DESCRIPTION="A DBus service providing easy to use API for using OBEX"
HOMEPAGE="http://tadas.dailyda.com/blog/category/obex-data-server/"
SRC_URI="http://tadas.dailyda.com/software/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"

IUSE="debug gtk imagemagick usb"

RDEPEND="dev-libs/glib:2
	>=dev-libs/dbus-glib-0.7
	sys-apps/dbus
	>=net-wireless/bluez-4.31
	>=dev-libs/openobex-1.3
	imagemagick? ( !gtk? ( media-gfx/imagemagick ) )
	gtk? ( x11-libs/gtk+ )
	usb? ( dev-libs/libusb:0 )
	!app-mobilephone/obexd"
DEPEND="dev-util/pkgconfig
	${RDEPEND}"

src_configure() {
	local bip="no"
	use imagemagick && bip="magick"
	use gtk && bip="gdk-pixbuf"
	econf \
		--enable-bip=${bip} \
		$(use_enable usb) \
		--disable-system-config \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
