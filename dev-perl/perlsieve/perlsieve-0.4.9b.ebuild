# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/perlsieve/perlsieve-0.4.9b.ebuild,v 1.13 2005/08/26 01:17:12 agriffis Exp $

inherit perl-module

S=${WORKDIR}/perlsieve-0.4.9
DESCRIPTION="Access Sieve services"
HOMEPAGE="http://sourceforge.net/projects/websieve/"
SRC_URI="http://lists.opensoftwareservices.com/websieve/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~ia64 ~mips ppc s390 sparc x86"
IUSE=""
