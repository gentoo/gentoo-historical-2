# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvdnav/libdvdnav-9999.ebuild,v 1.3 2011/10/10 17:19:11 ssuominen Exp $

EAPI=4
WANT_AUTOCONF=2.5

inherit autotools libtool multilib subversion

DESCRIPTION="Library for DVD navigation tools"
HOMEPAGE="http://mplayerhq.hu/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DOCS=( AUTHORS DEVELOPMENT-POLICY.txt ChangeLog TODO doc/dvd_structures README )

ESVN_REPO_URI="svn://svn.mplayerhq.hu/dvdnav/trunk/libdvdnav"
ESVN_PROJECT="libdvdnav"

src_prepare() {
	subversion_src_prepare
	elibtoolize
	eautoreconf
}

src_install() {
	default
	rm -f "${ED}"usr/lib*/${PN}*.la
}
