# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsupertone/libsupertone-0.0.2.ebuild,v 1.1 2006/10/26 18:22:35 gustavoz Exp $

IUSE=""

DESCRIPTION="A library for supervisory tone generation and detection"
HOMEPAGE="http://www.soft-switch.org/"

UNICALL_VER="0.0.3pre9"
SRC_URI="http://www.soft-switch.org/downloads/unicall/unicall-${UNICALL_VER}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND=">=dev-libs/libxml2-2.6.26
	>=media-libs/audiofile-0.2.6-r1
	>=media-libs/spandsp-0.0.2_pre26
	>=media-libs/tiff-3.8.2-r2"

MAKEOPTS="${MAKEOPTS} -j1"

# Upstream has different versions with the same filename
RESTRICT="mirror"

src_install () {
	make DESTDIR=${D} install || die "Install failed"
	dodoc AUTHORS COPYING INSTALL NEWS README
}
