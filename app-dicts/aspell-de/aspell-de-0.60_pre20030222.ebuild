# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/aspell-de/aspell-de-0.60_pre20030222.ebuild,v 1.7 2007/05/12 10:27:49 corsair Exp $

ASPELL_LANG="German and Swiss-German"
ASPOSTFIX="6"

inherit aspell-dict

LICENSE="GPL-2"

KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

FILENAME=aspell6-de-20030222-1

SRC_URI="mirror://gnu/aspell/dict/de/${FILENAME}.tar.bz2"
S=${WORKDIR}/${FILENAME}

