# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-FTPServer/Net-FTPServer-1.120.ebuild,v 1.5 2005/04/29 01:23:40 mcummings Exp $

inherit perl-module

DESCRIPTION="A secure, extensible and configurable Perl FTP server"
HOMEPAGE="http://search.cpan.org/~rwmj/${P}/"
SRC_URI="mirror://cpan/authors/id/R/RW/RWMJ/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="postgres"
SRC_TEST="do"

DEPEND="dev-perl/Archive-Zip
		dev-perl/Authen-PAM
		dev-perl/BSD-Resource
		dev-perl/Compress-Zlib
		dev-perl/Digest-MD5
		dev-perl/File-Temp
		dev-perl/Getopt-Long
		dev-perl/libnet
		dev-perl/File-Sync
		dev-perl/IO-stringy
		postgres? ( dev-perl/DBI )"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:/etc:${D}/etc:" Makefile.PL
}
