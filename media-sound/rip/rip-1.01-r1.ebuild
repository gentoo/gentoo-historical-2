# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: George Shapovalov <georges@its.caltech.edu>
# /space/gentoo/cvsroot/gentoo-x86/media-sound/rip/rip-1.01-r1.ebuild,v 1.4 2002/03/12 16:05:09 tod Exp


S="${WORKDIR}/${P}"
DESCRIPTION="A command-line based audio CD ripper and mp3 encoder"
SRC_URI="http://rip.sourceforge.net/download/${P}.tar.gz"
HOMEPAGE="http://rip.sourceforge.net"

DEPEND=""

RDEPEND="media-sound/cdparanoia
	sys-devel/perl
	>=dev-perl/CDDB_get-1.66
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
