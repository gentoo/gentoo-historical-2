# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/howto-text/howto-text-20050504.ebuild,v 1.1 2005/05/05 00:37:10 vapier Exp $

DESCRIPTION="The LDP howtos, text format"
HOMEPAGE="http://www.tldp.org/"
SRC_URI="mirror://gentoo/Linux-HOWTOs-${PV}.tar.bz2"

LICENSE="GPL-2 LDP"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE=""

S=${WORKDIR}

src_install() {
	insinto /usr/share/doc/howto/text
	doins * || die "doins failed"
	prepalldocs
	dosym howto /usr/share/doc/HOWTO
}
