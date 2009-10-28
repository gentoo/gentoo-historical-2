# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PAR-Dist/PAR-Dist-0.46.ebuild,v 1.6 2009/10/28 18:08:33 armin76 Exp $

EAPI=2

MODULE_AUTHOR=SMUELLER
inherit perl-module

DESCRIPTION="Create and manipulate PAR distributions"

SLOT="0"
KEYWORDS="amd64 hppa ia64 sparc x86"
IUSE=""

DEPEND="
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	|| ( dev-perl/YAML-Syck dev-perl/yaml )
	dev-perl/Archive-Zip"
	# || ( YAML::Syck YAML YAML-Tiny YAML-XS Parse-CPAN-Meta )
RDEPEND="${DEPEND}"

SRC_TEST="do"
