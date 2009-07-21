# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/christine/christine-0.4.0.ebuild,v 1.1 2009/07/21 15:24:55 ssuominen Exp $

EAPI=2
inherit autotools eutils multilib python

DESCRIPTION="Python, GTK+ and GStreamer based media player (audio and video)"
HOMEPAGE="http://christine-project.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="libnotify nls readline"

RDEPEND="readline? ( sys-libs/readline )
	libnotify? ( dev-python/notify-python )
	dev-python/pygtk
	dev-python/gconf-python
	dev-python/gst-python:0.10
	media-plugins/gst-plugins-meta:0.10
	media-libs/mutagen"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext
		dev-util/intltool )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no_static_linking.patch
	eautoreconf
}

src_configure() {
	addwrite /root/.gstreamer-0.10

	econf \
		--disable-dependency-tracking \
		--disable-static \
		$(use_enable nls) \
		$(use_with readline)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/lib${PN}
}

pkg_postrm() {
	python_mod_cleanup
}
