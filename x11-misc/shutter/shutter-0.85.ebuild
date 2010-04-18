# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/shutter/shutter-0.85.ebuild,v 1.3 2010/04/18 14:38:16 hwoarang Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Feature-rich screenshot program"
HOMEPAGE="http://shutter-project.org/"
SRC_URI="http://shutter-project.org/wp-content/uploads/releases/tars/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="drawing webphoto"

RDEPEND="dev-lang/perl
	dev-perl/gnome2-gconf
	drawing? ( dev-perl/Goo-Canvas  )
	webphoto? ( gnome-extra/gnome-web-photo )
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	dev-perl/libxml-perl
	dev-perl/gnome2-wnck
	dev-perl/gnome2-canvas
	dev-perl/gnome2-perl
	dev-perl/Gtk2-ImageView
	dev-perl/File-DesktopEntry
	dev-perl/File-HomeDir
	dev-perl/File-Which
	dev-perl/File-Copy-Recursive
	dev-perl/File-MimeInfo
	dev-perl/Locale-gettext
	dev-perl/Net-DBus
	dev-perl/Proc-Simple
	dev-perl/Sort-Naturally
	dev-perl/WWW-Mechanize
	dev-perl/X11-Protocol
	dev-perl/XML-Simple
	dev-perl/libwww-perl"

src_prepare() {
	use webphoto || epatch "${FILESDIR}"/disable_webphoto.patch
	use drawing || epatch "${FILESDIR}"/disable_goocanvas.patch
}

src_install() {
	dobin bin/${PN} || die "dobin failed"
	insinto /usr/share/${PN}
	doins -r share/${PN}/* || die "doins failed"
	dodoc README || die "dodoc failed"
	domenu share/applications/${PN}.desktop
	doman share/man/man1/${PN}.1.gz || die "doman failed"
	doicon share/pixmaps/${PN}.svg
	doins -r share/locale || die "doins failed"
	find "${D}"/usr/share/shutter/resources/system/plugins/ -type f ! -name '*.*' -exec chmod 755 {} \; \
		|| die "failed to make plugins executables"
}
