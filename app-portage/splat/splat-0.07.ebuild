# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/splat/splat-0.07.ebuild,v 1.4 2004/05/04 22:49:57 kloeri Exp $

DESCRIPTION="Simple Portage Log Analyzer Tool"
SRC_URI="http://www.l8nite.net/projects/splat/downloads/${P}.tar.bz2"
HOMEPAGE="http://www.l8nite.net/projects/splat/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc amd64 alpha"
DEPEND="dev-lang/perl"

src_install() {
	newbin splat.pl splat
	dodoc COPYING ChangeLog
}
