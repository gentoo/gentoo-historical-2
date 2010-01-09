# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Data-Inheritable/Class-Data-Inheritable-0.08.ebuild,v 1.7 2010/01/09 17:28:03 grobian Exp $

MODULE_AUTHOR=TMTM
inherit perl-module

DESCRIPTION="Exception::Class module for perl"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

export OPTIMIZE="${CFLAGS}"
DEPEND="dev-lang/perl"
