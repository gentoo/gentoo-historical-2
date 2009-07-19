# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-FTPServer/Net-FTPServer-1.122.ebuild,v 1.13 2009/07/19 17:41:32 tove Exp $

inherit perl-module

DESCRIPTION="A secure, extensible and configurable Perl FTP server"
HOMEPAGE="http://search.cpan.org/~rwmj/${P}/"
SRC_URI="mirror://cpan/authors/id/R/RW/RWMJ/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE="postgres test"
SRC_TEST="do"
PATCHES="${FILESDIR}/240abort.patch
		${FILESDIR}/makefile.patch"

DEPEND="dev-perl/Archive-Zip
	dev-perl/Authen-PAM
		dev-perl/BSD-Resource
		>=virtual/perl-IO-Compress-1.14
		virtual/perl-Digest-MD5
		virtual/perl-File-Temp
		virtual/perl-Getopt-Long
		virtual/perl-libnet
		dev-perl/File-Sync
		dev-perl/IO-stringy
		postgres? ( dev-perl/DBI )
		test? ( app-arch/ncompress )
		dev-lang/perl"
