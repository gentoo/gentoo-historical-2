# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/class-loader/class-loader-2.03.ebuild,v 1.11 2010/01/09 18:54:56 grobian Exp $

inherit perl-module

MY_P=Class-Loader-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Load modules and create objects on demand"
HOMEPAGE="http://search.cpan.org/~vipul/"
SRC_URI="mirror://cpan/authors/id/V/VI/VIPUL/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND="dev-lang/perl"
