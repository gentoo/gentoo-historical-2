# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-extra/xmms-extra-0.1.ebuild,v 1.12 2006/02/18 15:28:05 metalgod Exp $

inherit eutils gnuconfig

IUSE=""

DESCRIPTION="extra collection of commandline tools to control xmms"
HOMEPAGE="http://www.xmms.org/plugins.php?details=5"
SRC_URI="http://www.xmms.org/files/plugins/xmms-extra/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

RDEPEND=">=media-sound/xmms-1.2.7"

src_compile() {
	gnuconfig_update
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
