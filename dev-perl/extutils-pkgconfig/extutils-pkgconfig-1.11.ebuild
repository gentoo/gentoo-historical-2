# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/extutils-pkgconfig/extutils-pkgconfig-1.11.ebuild,v 1.4 2009/06/22 16:42:55 armin76 Exp $

inherit perl-module

MY_P=ExtUtils-PkgConfig-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Simplistic perl interface to pkg-config"
HOMEPAGE="http://search.cpan.org/~tsch/ExtUtils-PkgConfig/"
SRC_URI="mirror://cpan/authors/id/T/TS/TSCH//${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 ~mips ~ppc ~ppc64 sh sparc x86"
IUSE=""

DEPEND="dev-lang/perl
	dev-util/pkgconfig"
RDEPEND="${DEPEND}"

SRC_TEST="do"
