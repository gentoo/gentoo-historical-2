# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/media-player-info/media-player-info-21.ebuild,v 1.1 2013/07/24 14:13:27 tetromino Exp $

EAPI=5

DESCRIPTION="A repository of data files describing media player capabilities"
HOMEPAGE="http://cgit.freedesktop.org/media-player-info/"
SRC_URI="http://www.freedesktop.org/software/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

# http://cgit.freedesktop.org/media-player-info/commit/?id=d83dd01a0a1df6198ee08954da1c033b88a1004b
RDEPEND=">=virtual/udev-196[hwdb]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS NEWS README"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

pkg_postinst() {
	# Run for /lib/udev/hwdb.d/20-usb-media-players.hwdb
	udevadm hwdb --update --root="${ROOT%/}"
}
