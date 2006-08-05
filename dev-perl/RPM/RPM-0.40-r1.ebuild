# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/RPM/RPM-0.40-r1.ebuild,v 1.12 2006/08/05 20:11:07 mcummings Exp $

inherit perl-module

MY_P=Perl-${P}
S=${WORKDIR}/${MY_P}
DESCRIPTION="RPM:: module for perl"
SRC_URI="mirror://cpan/authors/id/RJRAY/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/RJRAY/Perl-RPM-${PV}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ppc sparc alpha"
IUSE=""

DEPEND="=app-arch/rpm-4.0.4-r5
	dev-lang/perl"
RDEPEND="${DEPEND}"

export OPTIMIZE="${CFLAGS}"
mydoc="ToDo"

