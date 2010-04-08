# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Schedule-At/Schedule-At-1.10.ebuild,v 1.1 2010/04/08 07:29:36 tove Exp $

EAPI=2

MODULE_AUTHOR=JOSERODR
inherit perl-module

DESCRIPTION="OS independent interface to the Unix 'at' command"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"
IUSE=""

RDEPEND="sys-process/at"
DEPEND="${RDEPEND}"

#SRC_TEST="do"
