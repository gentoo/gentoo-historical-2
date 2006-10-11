# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/canna-cannadic/canna-cannadic-0.95c.ebuild,v 1.6 2006/10/11 02:01:57 seemant Exp $

inherit cannadic

IUSE="canna"

MY_P="${P/canna-/}"

DESCRIPTION="Japanese dictionary as a supplement/replacement to the dictionaries distributed with Canna3.5b2"
HOMEPAGE="http://cannadic.oucrc.org/"
SRC_URI="http://cannadic.oucrc.org/${MY_P}.tar.gz"

KEYWORDS="x86 alpha sparc ppc ppc64 ~amd64"
LICENSE="GPL-2"
SLOT="0"
S="${WORKDIR}/${MY_P}"

DEPEND="canna? ( >=app-i18n/canna-3.6_p3-r1 )"

CANNADICS="gcanna gcannaf"
DICSDIRFILE="${FILESDIR}/05cannadic.dics.dir"

src_compile() {

	if use canna; then
		make maindic || die
	fi

}
