# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/srvx/srvx-1.3.0.2005_p2.ebuild,v 1.1 2005/01/07 08:26:03 swegener Exp $

inherit eutils

MY_P=${P/_/-}

DESCRIPTION="A complete set of services for IRCu 2.10.10+ and bahamut based networks"
HOMEPAGE="http://www.srvx.net/"
SRC_URI="http://www.blackhole.plus.com/simon/srvx/${MY_P}.tar.bz2
	http://www.macs.hw.ac.uk/~sa3/pub/srvx/${MY_P}.tar.bz2
	http://srvx.arlott.org/arch/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="bahamut"

DEPEND=">=sys-devel/automake-1.8
	>=sys-devel/autoconf-2.59"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
	local PROTOCOL="p10"
	use bahamut && PROTOCOL="bahamut"

	./autogen.sh || die "autogen.sh failed"

	econf \
		--with-protocol=$PROTOCOL \
		--enable-modules=helpserv,memoserv,sockcheck \
		|| die "econf failed"
	emake all-recursive || die "emake failed"
}

src_install() {
	dobin src/srvx || die "dobin failed"
	dodir /var/lib/srvx || die "dodir failed"

	insinto /etc/srvx
	newins srvx.conf.example srvx.conf || die "newins failed"
	newins sockcheck.conf.example sockcheck.conf || die "newins failed"
	dosym ../../../etc/srvx/srvx.conf /var/lib/srvx/srvx.conf || die "dosym failed"
	dosym ../../../etc/srvx/sockcheck.conf /var/lib/srvx/sockcheck.conf || die "dosym failed"

	insinto /usr/share/srvx
	for helpfile in \
		chanserv.help global.help mod-helpserv.help mod-memoserv.help \
		mod-sockcheck.help modcmd.help nickserv.help opserv.help \
		saxdb.help sendmail.help
	do
		doins "src/${helpfile}" || die "doins failed"
		dosym "../../../usr/share/srvx/${helpfile}" "/var/lib/srvx/${helpfile}" || die "dosym failed"
	done

	dodoc \
		AUTHORS INSTALL NEWS README TODO srvx.conf.example sockcheck.conf.example \
		docs/{access-levels,cookies,helpserv,ircd-modes}.txt || die "dodoc failed"

	newinitd ${FILESDIR}/srvx.init.d srvx || die "newinitd failed"
	newconfd ${FILESDIR}/srvx.conf.d srvx || die "newconfd failed"
}

pkg_setup() {
	enewgroup srvx
	enewuser srvx -1 /bin/false /var/lib/srvx srvx
}

pkg_postinst() {
	chown -R srvx:srvx ${ROOT}/etc/srvx ${ROOT}/var/lib/srvx
	chmod 0700 ${ROOT}/etc/srvx ${ROOT}/var/lib/srvx
}
