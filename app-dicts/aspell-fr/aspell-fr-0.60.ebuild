# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/aspell-fr/aspell-fr-0.60.ebuild,v 1.10 2008/11/01 12:12:52 pva Exp $

ASPELL_LANG="French"
ASPOSTFIX="6"

# This is a hack to allow for using the French 0.50 dictionary until I have
# the time to do this properly. Do not stabilise this.

inherit aspell-dict

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ppc64 ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"

FILENAME="aspell-fr-0.50-3"
SRC_URI="mirror://gnu/aspell/dict/fr/${FILENAME}.tar.bz2"
IUSE=""

S=${WORKDIR}/${FILENAME}
