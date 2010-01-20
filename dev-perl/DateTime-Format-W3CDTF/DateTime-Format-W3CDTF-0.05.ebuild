# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Format-W3CDTF/DateTime-Format-W3CDTF-0.05.ebuild,v 1.3 2010/01/20 16:24:18 tove Exp $

EAPI=2

MODULE_AUTHOR=DROLSKY
inherit perl-module

DESCRIPTION="Parse and format W3CDTF datetime strings"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/DateTime"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"

SRC_TEST="do"
