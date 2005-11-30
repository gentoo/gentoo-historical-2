# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-sv/ispell-sv-1.3.8.ebuild,v 1.1 2002/12/03 07:15:39 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="The Swedish dictionary for ispell"
SRC_URI="http://sv.speling.org/filer/${P}.tar.gz"
HOMEPAGE="http://sv.speling.org"

SLOT="0"
LICENSE="LGPL"
KEYWORDS="x86"

DEPEND="app-text/ispell"

src_compile() {
	
	# It's important that we export the TMPDIR environment variable,
	# so we don't commit sandbox violations
	export TMPDIR=/tmp
	emake || die
	unset TMPDIR

}

src_install () {
	insinto /usr/lib/ispell
	doins svenska.aff svenska.hash
	dodoc README contributors COPYING Copyright
}
