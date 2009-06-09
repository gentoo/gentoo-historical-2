# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Event-ICal/DateTime-Event-ICal-0.09.ebuild,v 1.1 2009/06/09 20:54:18 tove Exp $

EAPI=2

MODULE_AUTHOR=FGLOCK
inherit perl-module

DESCRIPTION="Perl DateTime extension for computing rfc2445 recurrences"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-perl/DateTime
	>=dev-perl/DateTime-Event-Recurrence-0.11"
DEPEND="${RDEPEND}"

SRC_TEST=do
