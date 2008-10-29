# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/realcodecs/realcodecs-11.0.1.1056.ebuild,v 1.1 2008/10/29 17:21:01 beandog Exp $

inherit eutils rpm multilib

EAPI="2"
DESCRIPTION="Real Player audio and video binary codecs"
HOMEPAGE="http://www.real.com/ http://player.helixcommunity.org/"
SRC_URI="http://forms.real.com/real/player/download.html?f=unix/RealPlayer11GOLD.rpm"
RESTRICT="mirror strip test binchecks"
LICENSE="HBRL"
KEYWORDS="-* ~amd64 ~x86"
SLOT="0"
IUSE=""
RDEPEND=">=media-libs/win32codecs-20071007-r4[real]
	x86? ( =virtual/libstdc++-3.3* )
	amd64? ( app-emulation/emul-linux-x86-compat )"

S="${WORKDIR}/opt/real/RealPlayer"

pkg_setup() {
	# This is a binary x86 package => ABI=x86
	# Please keep this in future versions
	# Danny van Dyk <kugelfang@gentoo.org> 2005/03/26
	has_multilib_profile && ABI="x86"
}

src_install() {
	dodir /opt/RealPlayer/

	fperms 644 codecs/*
	insinto "/opt/RealPlayer/codecs"
	doins codecs/*

	# We need symlinks to older codecs so that RealPlayer
	# can play some streams, bug 240417
	dosym /usr/$(get_libdir)/real/ddnt.so.6.0 \
		/opt/RealPlayer/codecs/ddnt.so.6.0
	dosym /usr/$(get_libdir)/real/dnet.so.6.0 \
		/opt/RealPlayer/codecs/dnet.so.6.0
	dosym /opt/RealPlayer/codecs/ddnt.so.6.0 \
		/opt/RealPlayer/codecs/ddnt.so
	dosym /opt/RealPlayer/codecs/dnet.so.6.0 \
		/opt/RealPlayer/codecs/dnet.so
}
