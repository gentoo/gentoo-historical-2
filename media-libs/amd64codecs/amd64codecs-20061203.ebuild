# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/amd64codecs/amd64codecs-20061203.ebuild,v 1.4 2007/02/11 23:56:10 blubb Exp $

inherit multilib

DESCRIPTION="64-bit binary codecs for video and audio playback support"
SRC_URI="mirror://mplayer/releases/codecs/essential-amd64-${PV}.tar.bz2"
HOMEPAGE="http://www.mplayerhq.hu/"
LICENSE="as-is"
SLOT="0"
KEYWORDS="-* amd64"
S="${WORKDIR}/essential-amd64-${PV}"
RESTRICT="nostrip"

src_install() {
	cd ${S}

	# see #83221
	insopts -m0644

	dodir /usr/$(get_libdir)/codecs
	insinto /usr/$(get_libdir)/codecs
	doins *.so

	dodoc README

	dodir /etc/revdep-rebuild
	cat - > "${D}/etc/revdep-rebuild/50amd64codecs" <<EOF
SEARCH_DIRS_MASK="/usr/$(get_libdir)/codecs"
EOF
}
