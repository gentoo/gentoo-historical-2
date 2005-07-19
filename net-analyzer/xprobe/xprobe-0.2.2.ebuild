# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/xprobe/xprobe-0.2.2.ebuild,v 1.5 2005/07/19 16:43:40 dholm Exp $

# This is new xprobe, so called xprobe2, due to xprobe1 being obsoleted.
# xprobe 2 has different approach to operating system fingerprinting.
# Xprobe2 rely on fuzzy signature matching, probabilistic guesses, multiple
# matches simultaneously, and a signature database.

DESCRIPTION="Active OS fingerprinting tool - this is Xprobe2"
SRC_URI="mirror://sourceforge/${PN}/${PN}2-${PV}.tar.gz"
HOMEPAGE="http://www.sys-security.com/index.php?page=xprobe"

KEYWORDS="~ppc ~sparc x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="virtual/libpcap"

S="${WORKDIR}/${PN}2-${PV}"

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS CREDITS COPYING
	dodoc CHANGELOG TODO README
	dodoc docs/*
}
