# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/aspell-da/aspell-da-1.4.33.ebuild,v 1.2 2004/06/24 21:32:21 agriffis Exp $

ASPELL_LANG="Danish"
inherit aspell-dict

HOMEPAGE="http://da.spelling.org"
SRC_URI="http://da.speling.org/filer/new_${P}.tar.gz"
S=${WORKDIR}/new_${P}

LICENSE="GPL-2"
