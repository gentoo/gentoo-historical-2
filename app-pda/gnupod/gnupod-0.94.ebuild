# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/gnupod/gnupod-0.94.ebuild,v 1.1 2004/06/23 03:52:14 matsuu Exp $

inherit perl-module

DESCRIPTION="A collection of Perl-scripts for iPod"
HOMEPAGE="http://www.gnu.org/software/gnupod/"
SRC_URI="http://blinkenlights.ch/gnupod-dist/stable/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

# perl-5.8.0 contains Getopt-Long and Digest-MD5.
DEPEND="dev-lang/perl
	dev-perl/MP3-Info
	dev-perl/XML-Parser
	dev-perl/Unicode-String
	|| ( >=dev-lang/perl-5.8.0
		( dev-perl/Getopt-Long
		dev-perl/Digest-MD5
		)
	)"

src_compile() {
	econf || die
}

src_install() {
	perlinfo
	sed -i -e "s:\$INC\[0\]/\$modi:${D}${SITE_ARCH}/\$modi:g" \
		tools/gnupod_install.pl || die

	dodir /usr/bin
	dodir ${SITE_ARCH}/GNUpod
	dodir /usr/share/info
	einstall || die

	dodoc AUTHORS BUGS CHANGES README* TODO doc/gnutunesdb.example
	dohtml doc/gnupod.html
}
