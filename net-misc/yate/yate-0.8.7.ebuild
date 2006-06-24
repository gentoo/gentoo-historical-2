# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/yate/yate-0.8.7.ebuild,v 1.6 2006/06/24 01:04:51 cardoe Exp $

IUSE="h323 postgres zaptel fax qt3 gtk gsm ortp"

inherit eutils

DESCRIPTION="YATE - Yet Another Telephony Engine"
HOMEPAGE="http://yate.null.ro/"
SRC_URI="http://voip.null.ro/tarballs/${P}.tar.gz"

S=${WORKDIR}/${PN}

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DEPEND="media-sound/sox
	postgres? ( dev-db/postgresql )
	zaptel? ( >=net-libs/libpri-1.0.0
	       >=net-misc/zaptel-1.0.0 )
	h323? ( >=net-libs/openh323-1.13.0 )
	fax? ( media-libs/spandsp )
	qt3? ( =x11-libs/qt-3* )
	gtk? ( <x11-libs/gtk+-2.0.0 )
	gsm? ( media-sound/gsm )
	ortp? ( net-libs/ortp )"

src_unpack() {
	unpack ${A}

	cd ${S}
	# patch for gcc3.4
	epatch ${FILESDIR}/${P}-gcc34.patch
}

src_compile() {
	econf \
		$(use_with postgres libpq /usr) \
		$(use_with fax spandsp /usr) \
		$(use_with qt3 libqt "${QTDIR}") \
		$(use_with gtk libgtk) \
		$(use_with h323 openh323 /usr) \
		$(use_with h323 pwlib /usr) \
		$(use_with zaptel libpri) \
		$(use_with gsm libgsm) \
		$(use_with ortp libortp /usr) \
		|| die "Configure failed"
	emake everything || die "Make failed"
}

src_install() {
	emake DESTDIR=${D} install || die "Make install failed"

	newinitd ${FILESDIR}/yate.rc6 yate
	newconfd ${FILESDIR}/yate.confd yate

	# install standard docs...
	dodoc README ChangeLog docs/*

	docinto scripts
	dodoc scripts/*
}
