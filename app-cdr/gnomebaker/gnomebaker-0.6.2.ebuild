# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/gnomebaker/gnomebaker-0.6.2.ebuild,v 1.7 2008/06/07 06:38:19 drac Exp $

inherit eutils gnome2

DESCRIPTION="GnomeBaker is a GTK2/Gnome cd burning application."
HOMEPAGE="http://gnomebaker.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="dvdr flac libnotify mp3 nls vorbis"
KEYWORDS="amd64 ~ia64 ~ppc ppc64 ~sparc x86"

RDEPEND="app-cdr/cdrdao
	virtual/cdrtools
	>=dev-libs/glib-2.4.0
	>=dev-libs/libxml2-2.4.0
	>=gnome-base/libglade-2.4.2
	>=gnome-base/libgnomeui-2.10
	>=media-libs/gstreamer-0.10.0
	x11-libs/cairo
	>=x11-libs/gtk+-2.8
	dev-perl/XML-Parser
	dvdr? ( app-cdr/dvd+rw-tools )
	flac? ( >=media-plugins/gst-plugins-flac-0.10.0
		media-libs/gst-plugins-good )
	libnotify? ( x11-libs/libnotify )
	mp3? ( >=media-plugins/gst-plugins-mad-0.10.0
		media-libs/gst-plugins-good	)
	vorbis? ( >=media-plugins/gst-plugins-vorbis-0.10.0
		>=media-libs/libogg-1.1.2
		media-libs/gst-plugins-good )"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	dev-util/pkgconfig"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable libnotify)"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	echo gnomebaker.desktop.in >> po/POTFILES.skip

	epatch "${FILESDIR}"/${P}-genisofs.patch \
		"${FILESDIR}"/${P}-fix_fstab_parsing.patch

	gnome2_omf_fix
}

src_install() {
	gnome2_src_install \
		gnomebakerdocdir=/usr/share/doc/${P} \
		docdir=/usr/share/gnome/help/${PN}/C \
		gnomemenudir=/usr/share/applications
	rm -rf "${D}"/usr/share/doc/${P}/*.make "${D}"/var
	use nls || rm -rf "${D}"/usr/share/locale
}
