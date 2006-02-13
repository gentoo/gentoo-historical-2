# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/choad/choad-0.822.ebuild,v 1.10 2006/02/13 14:49:31 mcummings Exp $

DESCRIPTION="a command-line, Perl-based CD-ripping-ID3-tagging-and-mp3-encoding utility"
HOMEPAGE="http://ftso.org/choad/index1.html"
SRC_URI="http://ftso.org/choad/choad.tgz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

IUSE="offensive"

DEPEND=">=dev-lang/perl-5
	dev-perl/CDDB
	virtual/perl-libnet
	dev-perl/MailTools
	media-sound/cdparanoia
	media-sound/lame"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	# Fix #! line
	sed -i -e '1s|pkg/||' choad

	# Install Perl script
	dobin choad

	# Documentation
	dodoc README.2ND

	# README.1ST is a little... colourful piece of ASCII art. :)
	if use offensive; then dodoc README.1ST; fi
}
