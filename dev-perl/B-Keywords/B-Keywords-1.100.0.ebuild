# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/B-Keywords/B-Keywords-1.100.0.ebuild,v 1.3 2012/08/26 18:07:22 armin76 Exp $

EAPI=4

MODULE_AUTHOR=FLORA
MODULE_VERSION=1.10
inherit perl-module

DESCRIPTION="Lists of reserved barewords and symbol names"

# GPL-2 - no later clause
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

SRC_TEST="do"
