# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Filesys-DiskSpace/Filesys-DiskSpace-0.05.ebuild,v 1.1 2006/04/03 18:22:21 mcummings Exp $

inherit perl-module

DESCRIPTION="Perl df"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/F/FT/FTASSIN/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86 ~sparc"
IUSE=""

#Disabled - assumes you have ext2 mounts actively mounted!?!
#SRC_TEST="do"

DEPEND=""
RDEPEND=""

