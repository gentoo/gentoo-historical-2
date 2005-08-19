# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/lighttpd/lighttpd-1.4.0.20050819.1044.ebuild,v 1.1 2005/08/19 14:57:12 ka0ttic Exp $

inherit eutils versionator

RESTRICT="test"

MY_PV="$(get_version_component_range 1-2).$(replace_all_version_separators '-' "$(get_version_component_range '3-5')")"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${PN}-${MY_PV%%-*}"
DESCRIPTION="lightweight high-performance web server"
HOMEPAGE="http://www.lighttpd.net/"
SRC_URI="http://www.lighttpd.net/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~x86"
IUSE="mysql ssl php xattr ldap ipv6"

RDEPEND="virtual/libc
		app-arch/bzip2
		>=dev-libs/libpcre-3.1
		>=sys-libs/zlib-1.1
		ldap? ( >=net-nds/openldap-2.1.26 )
		mysql? ( >=dev-db/mysql-4.0.0 )
		ssl? ( >=dev-libs/openssl-0.9.7 )
		php? (
			>=dev-php/php-cgi-4.3.0
			!net-www/spawn-fcgi
		)"

LIGHTTPD_DIR="/var/www/localhost/htdocs/"
LOG_DIR="/var/log/lighttpd/"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-1.3.11-gentoo.diff
	use php && epatch ${FILESDIR}/${PN}-1.3.13-php.diff
}

src_compile() {
	econf \
		--libdir=/usr/$(get_libdir)/${PN} \
		--enable-lfs \
		$(use_enable ipv6) \
		$(use_with mysql) \
		$(use_with ldap) \
		$(use_with xattr attr) \
		$(use_with ssl openssl) || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	keepdir ${LIGHTTPD_DIR} ${LOG_DIR}

	make DESTDIR="${D}" install || die "make install failed"

	insinto /etc
	doins doc/lighttpd.conf || die "doins failed"

	newinitd ${FILESDIR}/${PN}-1.3.10.initd ${PN}

	if use php ; then
		newinitd ${FILESDIR}/spawn-fcgi.initd spawn-fcgi
		newconfd ${FILESDIR}/spawn-fcgi.confd spawn-fcgi
	fi

	dodoc README COPYING
	cd doc
	dodoc *.txt *.sh
	newdoc lighttpd.conf lighttpd.conf.example || die "newdoc failed"
}

pkg_preinst() {
	enewgroup lighttpd || die "enewgroup failed"
	enewuser lighttpd -1 -1 "${LIGHTTPD_DIR}" lighttpd || die "enewuser failed"
	chown lighttpd:lighttpd ${IMAGE}${LOG_DIR}
}

pkg_postinst () {
	if [[ -f ${ROOT}/etc/conf.d/spawn-fcgi.conf ]] ; then
		einfo
		einfo "spawn-fcgi is now included with lighttpd"
		einfo "spawn-fcgi's init script configuration is now located"
		einfo "at /etc/conf.d/spawn-fcgi."
		einfo
	fi
}
