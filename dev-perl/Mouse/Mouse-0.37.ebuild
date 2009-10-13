# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mouse/Mouse-0.37.ebuild,v 1.2 2009/10/13 15:11:38 jer Exp $

EAPI=2

MODULE_AUTHOR=GFUJI
inherit perl-module

DESCRIPTION="Moose minus the antlers"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="test"

RDEPEND=""
DEPEND="test? ( dev-perl/Sub-Uplevel
	dev-perl/Test-Exception )"

SRC_TEST=do
