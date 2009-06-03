# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/pptpd/pptpd-1.3.4.ebuild,v 1.9 2009/06/03 22:28:21 flameeyes Exp $

WANT_AUTOMAKE="1.9"

inherit eutils autotools flag-o-matic

DESCRIPTION="Linux Point-to-Point Tunnelling Protocol Server"
SRC_URI="mirror://sourceforge/poptop/${P}.tar.gz"
HOMEPAGE="http://www.poptop.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="tcpd gre-extreme-debug"

DEPEND="net-dialup/ppp
	tcpd? ( sys-apps/tcp-wrappers )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-more-reodering-fixes.patch"

	#Match pptpd-logwtmp.so's version with pppd's version (#89895)
	local PPPD_VER=`best_version net-dialup/ppp`
	PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER%%[_-]*} # main version without beta/pre/patch/revision
	sed -i -e "s:\\(#define[ \\t]*VERSION[ \\t]*\\)\".*\":\\1\"${PPPD_VER}\":" "plugins/patchlevel.h"
	sed -e "/^LDFLAGS/{s:=:+=:}" -i plugins/Makefile

	eautomake
}

src_compile() {
	use gre-extreme-debug && append-flags "-DLOG_DEBUG_GRE_ACCEPTING_PACKET"
	local myconf
	use tcpd && myconf="--with-libwrap"
	econf --enable-bcrelay \
		${myconf} || die "configure failed"
	emake COPTS="${CFLAGS}" || die "make failed"
}

src_install () {
	einstall || die "make install failed"

	insinto /etc
	doins samples/pptpd.conf

	insinto /etc/ppp
	doins samples/options.pptpd

	newinitd "${FILESDIR}/pptpd-init" pptpd
	newconfd "${FILESDIR}/pptpd-confd" pptpd

	dodoc AUTHORS ChangeLog NEWS README* TODO
	docinto samples
	dodoc samples/*
}
