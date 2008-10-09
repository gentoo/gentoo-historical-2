# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/paman/paman-0.9.4-r1.ebuild,v 1.1 2008/10/09 21:39:25 flameeyes Exp $

EAPI=2

inherit eutils

DESCRIPTION="Pulseaudio Manager, a simple GTK frontend for Pulseaudio"
HOMEPAGE="http://0pointer.de/lennart/projects/paman/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 ~x86-fbsd"

IUSE=""

DEPEND=">=dev-cpp/gtkmm-2.4
	>=dev-cpp/libglademm-2.4
	>=media-sound/pulseaudio-0.9.5[glib]"
RDEPEND="${DEPEND}
	x11-themes/gnome-icon-theme"
DEPEND="${DEPEND}
	dev-util/pkgconfig"

src_configure() {
	# Lynx is used during make dist basically
	econf \
		--disable-lynx || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dohtml -r doc
	dodoc README
}
