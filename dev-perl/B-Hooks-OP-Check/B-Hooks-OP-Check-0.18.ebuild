# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/B-Hooks-OP-Check/B-Hooks-OP-Check-0.18.ebuild,v 1.1 2009/07/08 06:39:20 tove Exp $

EAPI=2

MODULE_AUTHOR=FLORA
inherit perl-module

DESCRIPTION="Wrap OP check callbacks"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/parent"
DEPEND=">=dev-perl/extutils-depends-0.302
	${RDEPEND}"

SRC_TEST=do
