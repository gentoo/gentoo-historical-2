# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openconnect/openconnect-4.07-r1.ebuild,v 1.1 2012/12/11 19:45:50 hwoarang Exp $

EAPI="5"

inherit eutils linux-info

DESCRIPTION="Free client for Cisco AnyConnect SSL VPN software"
HOMEPAGE="http://www.infradead.org/openconnect.html"
# New versions of openconnect-script can be found here:
# http://git.infradead.org/users/dwmw2/vpnc-scripts.git/history/HEAD:/vpnc-script
SRC_URI="ftp://ftp.infradead.org/pub/${PN}/${P}.tar.gz
	http://dev.gentoo.org/~hwoarang/distfiles/openconnect-script-20121108205904.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs nls -gnutls +openssl"
ILINGUAS="ar as ast bg bg_BG bn bn_IN bs ca ca@valencia cs da de el en_GB en_US eo es es_CR
	es_MX et eu fa fi fr gd gl gu he hi hi_IN hu id it ja km kn ko ku lo lt lv ml mr
	ms nb nl nn no or pa pl pt pt_BR pt_PT ro ru sk sl sq sr sr@latin sv ta te
	tg th tl tr ug uk ur_PK vi vi_VN wa zh_CN zh_HK zh_TW"
for lang in $ILINGUAS; do
	IUSE="${IUSE} linguas_${lang}"
done
# only one ssl provider can be enabled
REQUIRED_USE="^^ ( gnutls openssl )"

DEPEND="dev-libs/libxml2
	net-libs/libproxy
	sys-libs/zlib
	gnutls? (
		|| (
			( >=net-libs/gnutls-3[static-libs?] dev-libs/nettle )
			( =net-libs/gnutls-2.12*[nettle,static-libs?] dev-libs/nettle )
			( =net-libs/gnutls-2.12*[-nettle,static-libs?] dev-libs/libgcrypt[static-libs?] )
		)
		app-misc/ca-certificates
	)
	openssl? ( dev-libs/openssl[static-libs?] )"

RDEPEND="${DEPEND}
	 sys-apps/iproute2"

tun_tap_check() {
	ebegin "Checking for TUN/TAP support"
	if { ! linux_chkconfig_present TUN; }; then
		eerror "Please enable TUN/TAP support in your kernel config, found at:"
		eerror
		eerror "  Device Drivers  --->"
		eerror "    [*] Network device support  --->"
		eerror "      <*>   Universal TUN/TAP device driver support"
		eerror
		eerror "and recompile your kernel ..."
		die "no CONFIG_TUN support detected!"
	fi
	eend $?
}

pkg_setup() {
	if use kernel_linux; then
		get_version
		if linux_config_exists; then
			tun_tap_check
		else
			ewarn "Was unable to determine your kernel .config"
			ewarn "Please note that OpenConnect requires CONFIG_TUN to be set in your"
			ewarn "kernel .config, Without it, it will not work correctly."
			# We don't die here, so it's possible to compile this package without
			# kernel sources available. Required for cross-compilation.
		fi
	fi
}

src_configure() {
	strip-linguas $ILINGUAS
	echo ${LINGUAS} > po/LINGUAS
	# Override vpn-script test since the build system violates the sandbox and
	# needs the path set to the real default path after it's installed
	sed -e "s#-x \"\$with_vpnc_script\"#-n \"${WORKDIR}/openconnect-script\"#" \
		-i configure || die
	econf \
		--with-vpnc-script=/etc/openconnect/openconnect.sh \
		$(use_enable static-libs static) \
		$(use_enable nls ) \
		$(use_with openssl ) \
		$(use_with gnutls )
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS TODO
	newinitd "${FILESDIR}"/openconnect.init.in openconnect
	dodir /etc/openconnect
	insinto /etc/openconnect
	newconfd "${FILESDIR}"/openconnect.conf.in openconnect
	exeinto /etc/openconnect
	newexe "${WORKDIR}"/openconnect-script openconnect.sh
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/openconnect.logrotate openconnect
	keepdir /var/log/openconnect

	# Remove useless .la files
	find "${D}" -name '*.la' -delete || die "la file removal failed"
}

pkg_postinst() {
	elog "The init script for openconnect has changed and now supports multiple vpn tunnels."
	elog
	elog "You need to create a symbolic link to /etc/init.d/openconnect in /etc/init.d"
	elog "instead of calling it directly:"
	elog
	elog "ln -s /etc/init.d/openconnect /etc/init.d/openconnect.vpn0"
	elog
	elog "You can then start the vpn tunnel like this:"
	elog
	elog "/etc/init.d/openconnect.vpn0 start"
	elog
	elog "If you would like to run preup, postup, predown, and/or postdown scripts,"
	elog "You need to create a directory in /etc/openconnect with the name of the vpn:"
	elog
	elog "mkdir /etc/openconnect/vpn0"
	elog
	elog "Then add executable shell files:"
	elog
	elog "mkdir /etc/openconnect/vpn0"
	elog "cd /etc/openconnect/vpn0"
	elog "echo '#!/bin/sh' > preup.sh"
	elog "cp preup.sh predown.sh"
	elog "cp preup.sh postup.sh"
	elog "cp preup.sh postdown.sh"
	elog "chmod 755 /etc/openconnect/vpn0/*"
}
