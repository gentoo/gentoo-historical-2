# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/aspell-la/aspell-la-6.0.20020503.0.ebuild,v 1.13 2010/05/14 14:10:05 jer Exp $

ASPELL_LANG="Latin"
ASPOSTFIX="6"

inherit aspell-dict

LICENSE="GPL-2"

KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~sparc-fbsd ~x86-fbsd"

FILENAME="aspell6-la-20020503-0"
SRC_URI="mirror://gnu/aspell/dict/la/${FILENAME}.tar.bz2"
IUSE=""

S=${WORKDIR}/${FILENAME}
