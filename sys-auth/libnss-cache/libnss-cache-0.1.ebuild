# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/libnss-cache/libnss-cache-0.1.ebuild,v 1.1 2009/03/18 05:33:07 antarus Exp $

inherit eutils multilib

DESCRIPTION="libnss-cache is a library that serves nss lookups."
HOMEPAGE="http://code.google.com/p/nsscache/"
SRC_URI="http://nsscache.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${PV}-make-install.patch"
}

src_install() {
	emake LIBDIR=$(get_libdir)
}
