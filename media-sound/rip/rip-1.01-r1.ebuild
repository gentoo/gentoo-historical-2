# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rip/rip-1.01-r1.ebuild,v 1.14 2004/06/25 00:20:18 agriffis Exp $

IUSE=""

DESCRIPTION="A command-line based audio CD ripper and mp3 encoder"
SRC_URI="http://rip.sourceforge.net/download/${P}.tar.gz"
HOMEPAGE="http://rip.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

DEPEND=""

RDEPEND="media-sound/cdparanoia
	sys-apps/eject
	dev-lang/perl
	>=dev-perl/CDDB_get-2.10
	>=dev-perl/MP3-Info-0.91"

src_compile() {
	#the thing itself is just a perl script
	#so we need an empty method here
	echo "nothing to be done"

}

src_install () {

	chmod 755 rip
	dobin rip || die

	# Install documentation.
	dodoc COPYING FAQ README
}
