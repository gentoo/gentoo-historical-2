# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-AutoWriter/XML-AutoWriter-0.40.ebuild,v 1.3 2010/10/21 20:20:36 jer Exp $

MY_PV="0.4"
MY_P="${PN}-${MY_PV}"
MODULE_AUTHOR="PERIGRIN"

inherit perl-module

DESCRIPTION="DOCTYPE based XML output"
IUSE=""
SLOT="0"
LICENSE="as-is"
KEYWORDS="amd64 hppa ~ia64 ~sparc ~x86"

DEPEND="dev-perl/XML-Parser
	dev-lang/perl"

SRC_TEST="do"

S="${WORKDIR}/${MY_P}"
