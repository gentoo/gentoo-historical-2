# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/asr-manpages/asr-manpages-1.3_rc5.ebuild,v 1.7 2004/06/03 12:45:42 gustavoz Exp $

inherit eutils

MY_R="5"
MY_P="${PN}_${PV/_rc5/}"
DESCRIPTION="set of humorous manual pages developed on alt.sysadmin.recovery"
HOMEPAGE="http://debian.org/"
SRC_URI="mirror://debian/pool/main/a/asr-manpages/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/a/asr-manpages/${MY_P}-${MY_R}.diff.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc sparc hppa"
IUSE=""

RDEPEND="sys-apps/man"

S="${WORKDIR}/${MY_P/_/-}.orig"

src_unpack() {
	unpack ${A}
	epatch "${MY_P}-${MY_R}.diff"
}

src_install() {
	rm -rf debian
	doman *
}
