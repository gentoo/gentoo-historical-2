# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/psh/psh-1.8.ebuild,v 1.9 2004/11/09 21:16:36 mr_bones_ Exp $

inherit perl-module

DESCRIPTION="Combines the interactive nature of a Unix shell with the power of Perl"
HOMEPAGE="http://www.focusresearch.com/gregor/psh/"
SRC_URI="http://www.focusresearch.com/gregor/psh/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha ia64"
IUSE=""

DEPEND=">=dev-lang/perl-5"

myinst="SITEPREFIX=${D}/usr"
