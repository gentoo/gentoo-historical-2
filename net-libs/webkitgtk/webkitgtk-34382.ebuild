# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/webkitgtk/webkitgtk-34382.ebuild,v 1.1 2008/06/08 18:19:41 jokey Exp $

inherit autotools

MY_P="WebKit-r${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkit.org/"
SRC_URI="http://nightly.webkit.org/files/trunk/src/${MY_P}.tar.bz2"

LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug gstreamer sqlite svg"

RDEPEND=">=x11-libs/gtk+-2.0
	dev-libs/icu
	>=net-misc/curl-7.15
	media-libs/jpeg
	media-libs/libpng
	dev-libs/libxslt
	dev-libs/libxml2
	sqlite? ( >=dev-db/sqlite-3 )
	gstreamer? (
		>=media-libs/gstreamer-0.10
		>=media-libs/gst-plugins-base-0.10
		>=gnome-base/gnome-vfs-2.0
	)"

DEPEND="${RDEPEND}
	sys-devel/bison
	dev-util/gperf
	>=sys-devel/flex-2.5.33"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	eautoreconf
}

src_compile() {
	econf \
		$(use_enable sqlite database) \
		$(use_enable sqlite icon-database) \
		$(use_enable gstreamer video) \
		$(use_enable svg svg-experimental) \
		$(use_enable debug)

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
