# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/havp/havp-0.91.ebuild,v 1.1 2009/07/16 06:11:55 mrness Exp $

EAPI="2"

inherit eutils

DESCRIPTION="HTTP AntiVirus Proxy"
HOMEPAGE="http://www.server-side.de/"
SRC_URI="http://www.server-side.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clamav ssl"

DEPEND="clamav? ( app-antivirus/clamav )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup havp
	enewuser havp -1 -1 /etc/havp havp
}

src_configure() {
	econf --localstatedir=/var \
		$(use_enable clamav) \
		$(use_enable ssl ssl-tunnel) || die "configure failed"
}

src_install() {
	exeinto /usr/sbin
	doexe havp/havp

	newinitd "${FILESDIR}/havp.initd" havp
	insinto /etc
	doins -r etc/havp

	diropts -m 0700 -o havp -g havp
	keepdir /var/log/havp

	diropts -m 0750
	dodir /var/run/havp /var/tmp/havp

	dodoc ChangeLog
}

pkg_postinst() {
	ewarn "/var/tmp/havp must be on a filesystem with mandatory locks!"
	ewarn "You should add  \"mand\" to the mount options on the relevant line in /etc/fstab."

	if use ssl; then
		echo
		ewarn "Note: ssl USE flag only enable SSL pass-through, which means that"
		ewarn "      HTTPS pages will not be scanned for viruses!"
		ewarn "      It is impossible to decrypt data sent through SSL connections without knowing"
		ewarn "      the private key of the used certificate."
	fi

	if use clamav; then
		echo
		ewarn "If you plan to use clamav daemon, you should make sure clamav user can read"
		ewarn "/var/tmp/havp content. This can be accomplished by enabling AllowSupplementaryGroups"
		ewarn "in /etc/clamd.conf and adding clamav user to the havp group."
	fi
}
