# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Readonly-XS/Readonly-XS-1.05.ebuild,v 1.1 2010/04/10 11:17:23 tove Exp $

EAPI=2

MODULE_AUTHOR=ROODE
inherit perl-module

DESCRIPTION="Companion module for Readonly.pm, to speed up read-only scalar variables"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Readonly"
DEPEND="${RDEPEND}"

SRC_TEST=do
