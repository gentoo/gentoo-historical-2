# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/unrealircd/unrealircd-3.2.4.ebuild,v 1.1 2006/02/18 20:58:21 antarus Exp $

inherit eutils ssl-cert versionator

MY_P=Unreal${PV}

DESCRIPTION="aimed to be an advanced (not easy) IRCd"
HOMEPAGE="http://www.unrealircd.com/"
SRC_URI="http://unrealircd.funny4chat.de/downloads/${MY_P}.tar.gz
	http://www1.dnwt.net/unreal/${MY_P}.tar.gz
	http://www.randumb.org/~unreal/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE="hub ipv6 ssl zlib curl"

RDEPEND="ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )
	curl? ( net-misc/curl )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

S="${WORKDIR}/Unreal$(get_version_component_range 1-2)"

pkg_setup() {
	if use curl && ( ! built_with_use net-misc/curl ares || built_with_use net-misc/curl ipv6 )
	then
		eerror "You need net-misc/curl compiled with the ares USE flag to be able to use"
		eerror "net-irc/unrealircd with the curl USE flag. Please note that ares support"
		eerror "for net-misc/curl is incompatible with the ipv6 USE flag."
	die "need net-misc/curl with ares support"
	fi
	enewuser unrealircd
}

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i \
		-e "s:ircd\.pid:/var/run/unrealircd/ircd.pid:" \
		-e "s:ircd\.log:/var/log/unrealircd/ircd.log:" \
		-e "s:debug\.log:/var/log/unrealircd/debug.log:" \
		-e "s:ircd\.tune:/var/lib/unrealircd/ircd.tune:" \
		include/config.h
}

src_compile() {
	econf \
		--with-listen=5 \
		--with-dpath=${D}/etc/unrealircd \
		--with-spath=/usr/bin/unrealircd \
		--with-nick-history=2000 \
		--with-sendq=3000000 \
		--with-bufferpool=18 \
		--with-hostname=$(hostname -f) \
		--with-permissions=0600 \
		--with-fd-setsize=1024 \
		--enable-dynamic-linking \
		--enable-prefixaq \
		$(use_enable ipv6 inet6) \
		$(use_enable ssl) \
		$(use_enable zlib ziplinks) \
		$(use_enable hub) \
		$(use_enable curl libcurl '/usr') \
		|| die "econf failed"

	sed -i \
		-e "s:${D}::" \
		include/setup.h \
		ircdcron/ircdchk

	emake IRCDDIR=/etc/unrealircd || die "emake failed"
}

src_install() {
	keepdir /var/{lib,log,run}/unrealircd || die "keepdir failed"

	newbin src/ircd unrealircd || die "newbin failed"

	exeinto /usr/lib/unrealircd/modules
	doexe src/modules/*.so || die "doexe failed"

	dodir /etc/unrealircd || die "dodir failed"
	dosym /var/lib/unrealircd /etc/unrealircd/tmp || die "dosym failed"

	insinto /etc/unrealircd
	doins {badwords.*,help,spamfilter,dccallow}.conf || die "doins failed"
	newins doc/example.conf unrealircd.conf || die "newins failed"

	use ssl \
		&& docert server.cert \
		&& dosym server.cert.key /etc/unrealircd/server.key.pem

	insinto /etc/unrealircd/aliases
	doins aliases/*.conf || die "doins failed"
	insinto /etc/unrealircd/networks
	doins networks/*.network || die "doins failed"

	sed -i \
		-e s:src/modules:/usr/lib/unrealircd/modules: \
		-e s:ircd\\.log:/var/log/unrealircd/ircd.log: \
		${D}/etc/unrealircd/unrealircd.conf

	dodoc \
		Changes Donation Unreal.nfo networks/makenet \
		ircdcron/{ircd.cron,ircdchk} \
		|| die "dodoc failed"
	dohtml doc/*.html || die "dohtml failed"

	newinitd ${FILESDIR}/unrealircd.rc unrealircd || die "newinitd failed"
	newconfd ${FILESDIR}/unrealircd.confd unrealircd || die "newconfd failed"

	fperms 700 /etc/unrealircd
	chown -R unrealircd ${D}/{etc,var/{lib,log,run}}/unrealircd
}

pkg_postinst() {
	einfo
	einfo "UnrealIRCd will not run until you've set up /etc/unrealircd/unrealircd.conf"
	einfo
	einfo "You can find example cron scripts here:"
	einfo "   /usr/share/doc/${PF}/ircd.cron.gz"
	einfo "   /usr/share/doc/${PF}/ircdchk.gz"
	einfo
	einfo "You can also use /etc/init.d/unrealircd to start at boot"
	einfo
}
