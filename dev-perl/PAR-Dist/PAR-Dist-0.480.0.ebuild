# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PAR-Dist/PAR-Dist-0.480.0.ebuild,v 1.1 2011/11/06 08:16:59 tove Exp $

EAPI=4

MODULE_AUTHOR=SMUELLER
MODULE_VERSION=0.48
inherit perl-module

DESCRIPTION="Create and manipulate PAR distributions"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~sparc ~x86 ~x86-solaris"
IUSE=""

DEPEND="
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	|| ( dev-perl/YAML-Syck dev-perl/yaml )
	dev-perl/Archive-Zip"
	# || ( YAML::Syck YAML YAML-Tiny YAML-XS Parse-CPAN-Meta )
RDEPEND="${DEPEND}"

SRC_TEST="do"
