# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-config/ruby-config-0.3.1.ebuild,v 1.5 2004/11/04 16:13:49 usata Exp $

inherit eutils

DESCRIPTION="Utility to switch the ruby interpreter beging used"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc ~mips alpha ~arm ~hppa ~amd64 ~ia64 ~s390 ~ppc64 ~ppc-macos"
IUSE=""

RDEPEND="!<dev-ruby/ri-1.8b-r1"
PDEPEND="virtual/ruby"

S="${WORKDIR}"

src_unpack() {
	cp ${FILESDIR}/${PN}-0.3 .
	epatch ${FILESDIR}/${P}.diff
}

src_install() {
	newsbin ${PN}-0.3 ruby-config || die
}
