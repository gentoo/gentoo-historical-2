# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Flock/File-Flock-2008.01.ebuild,v 1.2 2009/09/30 16:36:44 armin76 Exp $

MODULE_AUTHOR="MUIR"
MODULE_SECTION="modules"

inherit perl-module

DESCRIPTION="flock() wrapper.  Auto-create locks"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~amd64 ~ia64 ~sparc ~x86"

SRC_TEST="do"
