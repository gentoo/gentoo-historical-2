# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/locale-maketext/locale-maketext-1.09.ebuild,v 1.3 2006/08/04 13:39:24 mcummings Exp $

inherit perl-module

MY_P=Locale-Maketext-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Localization framework for Perl programs"
HOMEPAGE="http://www.cpan.org/modules/by-module/Locale/${MY_P}.readme"
SRC_URI="mirror://cpan/authors/id/S/SB/SBURKE/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc s390 sparc x86"
IUSE=""

DEPEND="dev-lang/perl
		>=perl-core/i18n-langtags-0.30"
RDEPEND="${DEPEND}"

SRC_TEST="do"
