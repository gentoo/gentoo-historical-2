# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/aspell-ca/aspell-ca-0.60.20040130.ebuild,v 1.2 2007/08/04 16:37:27 philantrop Exp $

ASPELL_LANG="Catalan"
ASPOSTFIX="6"

inherit aspell-dict

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

FILENAME="aspell6-ca-20040130-1"
SRC_URI="mirror://gnu/aspell/dict/ca/${FILENAME}.tar.bz2"
S=${WORKDIR}/${FILENAME}
