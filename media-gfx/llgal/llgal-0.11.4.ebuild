# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/llgal/llgal-0.11.4.ebuild,v 1.5 2006/03/22 13:17:50 nattfodd Exp $

DESCRIPTION="Command-line online gallery generator"
HOMEPAGE="http://home.gna.org/llgal"
SRC_URI="http://download.gna.org/llgal/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="media-gfx/imagemagick
	 dev-lang/perl
	 dev-perl/ImageSize
	 dev-perl/ImageInfo
	 dev-perl/URI"

src_compile() {
	make PREFIX=/usr SYSCONFDIR=/etc MANDIR=/usr/share/man \
	|| die "Failed to compile"
}

src_install() {
	make DESTDIR="${D}/" PREFIX=/usr SYSCONFDIR=/etc MANDIR=/usr/share/man \
	install || die "Failed to install"
	dodoc Changes UPGRADE
}
