# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/quickrip/quickrip-0.6.ebuild,v 1.6 2004/05/04 12:42:25 kloeri Exp $

inherit eutils

MY_PV="$(echo ${PV} | cut -d. -f1,2)"
S="${WORKDIR}/QuickRip"
DESCRIPTION="Basic DVD ripper written in Python and PyQT."
HOMEPAGE="http://www.tomchance.uklinux.net/projects/quickrip.shtml"
SRC_URI="http://www.tomchance.uklinux.net/projects/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 -ppc -mips"
IUSE=""

DEPEND="virtual/glibc
	>=dev-lang/python-2.2
	>=x11-libs/qt-3.1
	>=dev-python/PyQt-3.5
	media-video/mplayer
	media-video/transcode"

src_install() {
	exeinto /usr/share/quickrip
	doexe *.py ui/*.ui

	dodoc README LICENSE
	dodir /usr/bin
	dosym /usr/share/quickrip/quickrip.py /usr/bin/quickrip
}
