# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Perl-Critic/Perl-Critic-1.082.ebuild,v 1.2 2008/04/24 19:41:17 fmccor Exp $

inherit perl-module versionator

MY_P="${PN}-$(delete_version_separator 2)"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Critique Perl source code for best-practices"
HOMEPAGE="http://search.cpan.org/~thaljef"
SRC_URI="mirror://cpan/authors/id/E/EL/ELLIOTJS/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~sparc ~x86"
IUSE=""

SRC_TEST="do"

RDEPEND=">=dev-perl/Module-Pluggable-3.1
	>=dev-perl/Config-Tiny-2
	dev-perl/List-MoreUtils
	dev-perl/IO-String
	dev-perl/String-Format
	dev-perl/perltidy
	>=dev-perl/PPI-1.118
	>=dev-perl/set-scalar-1.20
	dev-perl/B-Keywords
	dev-perl/Readonly
	dev-perl/Exception-Class
	dev-lang/perl"
DEPEND="dev-perl/module-build"

mydoc="extras/* examples/*"
