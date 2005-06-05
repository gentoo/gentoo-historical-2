# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/note/note-1.2.5-r1.ebuild,v 1.8 2005/06/05 11:53:32 hansmi Exp $

inherit perl-module

DESCRIPTION="a note taking perl program"
HOMEPAGE="http://www.daemon.de/NOTE"
SRC_URI="ftp://ftp.daemon.de/scip/Apps/note/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="crypt mysql"

DEPEND="dev-perl/TermReadKey
	dev-perl/Term-ReadLine-Perl
	crypt? ( dev-perl/crypt-cbc dev-perl/Crypt-Blowfish dev-perl/Crypt-DES )
	mysql? ( dev-db/mysql dev-perl/DBD-mysql )"

src_install() {
	perl-module_src_install
	dodoc README
}
