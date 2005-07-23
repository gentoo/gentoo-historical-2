# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-config/ruby-config-0.3.1.ebuild,v 1.12 2005/07/23 11:55:20 matsuu Exp $

inherit eutils

DESCRIPTION="Utility to switch the ruby interpreter beging used"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 ppc-macos s390 sh sparc x86"
IUSE=""

RDEPEND="!<dev-ruby/ri-1.8b-r1"
PDEPEND="virtual/ruby"

S=${WORKDIR}

src_unpack() {
	cp ${FILESDIR}/${PN}-0.3 .
	epatch ${FILESDIR}/${P}.diff
}

src_install() {
	newsbin ${PN}-0.3 ruby-config || die
}
