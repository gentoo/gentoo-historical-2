# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MooseX-Types-Path-Class/MooseX-Types-Path-Class-0.50.0.ebuild,v 1.1 2011/08/29 17:34:07 tove Exp $

EAPI=4

MODULE_AUTHOR=THEPLER
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="A Path::Class type library for Moose"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	|| ( >=dev-perl/Moose-1.990 dev-perl/Class-MOP )
	>=dev-perl/Moose-0.39
	>=dev-perl/MooseX-Types-0.04
	>=dev-perl/Path-Class-0.16"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do"
