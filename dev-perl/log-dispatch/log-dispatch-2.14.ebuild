# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/log-dispatch/log-dispatch-2.14.ebuild,v 1.4 2007/01/22 16:12:55 kloeri Exp $

inherit perl-module

MY_P=Log-Dispatch-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Dispatches messages to multiple Log::Dispatch::* objects"
SRC_URI="mirror://cpan/authors/id/D/DR/DROLSKY/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/D/DR/DROLSKY/"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ~ppc sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND=">=dev-perl/module-build-0.28
	dev-perl/Params-Validate
	dev-lang/perl"
