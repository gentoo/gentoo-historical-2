# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/radiostation/radiostation-0.5.ebuild,v 1.6 2004/06/25 00:19:03 agriffis Exp $

DESCRIPTION="Managements system for online audio streams"
HOMEPAGE="http://mindx.dyndns.org/kde/radio/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE="debug kde"

# We don't inherit kde-base because we might not need to install the kde
# related components, and if that's the case, we don't want to accidently
# pull in kde as a dependency

DEPEND="kde? ( >=kde-base/kdelibs-3.1 )
	dev-util/dialog
	net-www/lynx
	net-misc/wget
	media-sound/xmms"

S=${WORKDIR}/kderadiostation-${PV}
SRC_URI="http://mindx.dyndns.org/kde/radio/source/kderadiostation-${PV}.tar.gz
	 http://mindx.dyndns.org/kde/radio/source/radiostation"

src_unpack() {
	if use kde; then
		unpack kderadiostation-${PV}.tar.gz
	fi

	cp ${DISTDIR}/radiostation ${WORKDIR}
}

src_compile() {
	if use kde; then
		econf `use_enable debug` || die "Unsuccessful configure"
		emake || die "Unsuccessful make"
	fi
}

src_install() {
	if use kde; then
		einstall || die "Unsuccessful install"
		dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
	fi

	dobin ${WORKDIR}/radiostation
}
