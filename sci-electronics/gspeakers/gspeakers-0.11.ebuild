# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gspeakers/gspeakers-0.11.ebuild,v 1.6 2009/02/15 22:08:49 dirtyepic Exp $

inherit eutils gnome2

DESCRIPTION="GTK based loudspeaker enclosure and crossovernetwork designer"
HOMEPAGE="http://gspeakers.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="amd64 x86 ~ppc"
IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.4
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
RDEPEND="${RDEPEND}
	|| ( >=sci-electronics/gnucap-0.34
		sci-electronics/ng-spice-rework
		sci-electronics/spice )"

DOCS="README* INSTALL Changelog AUTHORS NEWS ABOUT"

src_unpack() {
	gnome2_src_unpack
	epatch "${FILESDIR}"/${P}-gcc43.patch
}
