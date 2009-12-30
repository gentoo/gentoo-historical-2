# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/cacti-spine/cacti-spine-0.8.7e-r1.ebuild,v 1.4 2009/12/30 13:17:55 armin76 Exp $

inherit autotools

UPSTREAM_PATCHES="snmp_v3_fix
	mysql_client_reconnect
	ping_reliability"

MY_P=${PN}-${PV/_p/-}

DESCRIPTION="Spine is a fast poller for Cacti (formerly known as Cactid)"
HOMEPAGE="http://cacti.net/spine_info.php"
SRC_URI="http://www.cacti.net/downloads/spine/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 sparc x86"
IUSE=""

DEPEND="net-analyzer/net-snmp
	dev-libs/openssl
	virtual/mysql"
RDEPEND="${DEPEND}
	>net-analyzer/cacti-0.8.7"

if [[ -n ${UPSTREAM_PATCHES} ]]; then
	for i in ${UPSTREAM_PATCHES}; do
		SRC_URI="${SRC_URI} http://www.cacti.net/downloads/spine/patches/${i}.patch"
	done
fi

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd "${S}"
	if [[ -n ${UPSTREAM_PATCHES} ]]; then
		for i in ${UPSTREAM_PATCHES} ; do
			EPATCH_OPTS="-p1 -N" epatch "${DISTDIR}"/${i}.patch
		done
	fi

	sed -i -e 's/^bin_PROGRAMS/sbin_PROGRAMS/' Makefile.am
	AT_M4DIR="config" eautoreconf
}

src_install() {
	dosbin spine || die
	insinto /etc/
	insopts -m0640 -o root
	doins spine.conf || die
	dodoc ChangeLog README || die
}

pkg_postinst() {
	ewarn "NOTE: If you upgraded from cactid, do not forgive to setup spine"
	ewarn "instead of cactid through web interface."
	ewarn
	elog "Please see the cacti's site for installation instructions:"
	elog
	elog "http://cacti.net/spine_install.php"
	echo
	ewarn "/etc/spine.conf should be readable by webserver, thus after you"
	ewarn "decide on webserver do not forget to run the following command:"
	ewarn
	ewarn " # chown root:wwwgroup /etc/spine.conf"
	echo
}
