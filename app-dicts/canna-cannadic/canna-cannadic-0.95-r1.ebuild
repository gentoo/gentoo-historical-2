# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/canna-cannadic/canna-cannadic-0.95-r1.ebuild,v 1.3 2003/09/30 13:01:38 usata Exp $

inherit cannadic

IUSE="canna"

MY_P="${P/canna-/}"

DESCRIPTION="Japanese dictionary as a supplement/replacemnt to the dictionaries distributed with Canna3.5b2"
HOMEPAGE="http://cannadic.oucrc.org/"
SRC_URI="http://cannadic.oucrc.org/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="canna? >=canna-3.6_p3-r1"

S="${WORKDIR}/${MY_P}"

CANNADICS="gcanna gcannaf"
DICSDIRFILE="${FILESDIR}/05cannadic.dics.dir"

src_compile() {

	if [ -n "`use canna`" ] ; then
		make maindic || die
	fi
}
