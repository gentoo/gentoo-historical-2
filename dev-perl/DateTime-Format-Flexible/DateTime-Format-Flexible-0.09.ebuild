# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Format-Flexible/DateTime-Format-Flexible-0.09.ebuild,v 1.2 2009/06/10 12:57:50 tove Exp $

EAPI=2

MODULE_AUTHOR=THINC
inherit perl-module

DESCRIPTION="Flexibly parse strings and turn them into DateTime objects"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/DateTime
	>=dev-perl/DateTime-Format-Builder-0.74
	dev-perl/DateTime-TimeZone
	dev-perl/Readonly"
DEPEND="${RDEPEND}"

SRC_TEST=do
