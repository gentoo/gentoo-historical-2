# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cdstatus/cdstatus-0.95.04.ebuild,v 1.1 2005/04/23 10:42:23 luckyduck Exp $

inherit eutils

DESCRIPTION="Tool for diagnosing cdrom drive and digital data (audio) extraction"
HOMEPAGE="http://cdstatus.sourceforge.net/"
SRC_URI="mirror://sourceforge/cdstatus/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#-sparc -amd64: 0.94a: Generates bad wav files  x86 is good...
KEYWORDS="~x86 -amd64 -sparc ~ppc64"
IUSE=""

DEPEND="virtual/libc"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
}

pkg_postinst() {
	einfo ""
	einfo "Copy cdstatus.cfg from /usr/share/cdstatus.cfg"
	einfo "to your home directory and edit as needed."
	einfo ""
}
