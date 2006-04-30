# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/pdns/pdns-2.9.20.ebuild,v 1.4 2006/04/30 00:14:14 swegener Exp $

inherit multilib eutils

DESCRIPTION="The PowerDNS Daemon"
SRC_URI="http://downloads.powerdns.com/releases/${P}.tar.gz"
HOMEPAGE="http://www.powerdns.com/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc ldap mysql postgres recursor sqlite static tdb"

DEPEND="mysql? ( >=dev-db/mysql-3.23.54a )
	postgres? ( >=dev-cpp/libpqpp-4.0-r1 )
	ldap? ( >=net-nds/openldap-2.0.27-r4 )
	sqlite? ( =dev-db/sqlite-2.8* )
	tdb? ( dev-libs/tdb )
	>=dev-libs/boost-1.31"

RDEPEND="${DEPEND}
	recursor? ( !net-dns/pdns-recursor )"

DEPEND="${DEPEND}
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/2.9.18-default-mysql-options.patch
}

src_compile() {
	local modules="pipe geo" myconf=""

	use mysql && modules="${modules} gmysql"
	use postgres && modules="${modules} gpgsql"
	use sqlite && modules="${modules} gsqlite"
	use ldap && modules="${modules} ldap"
	use tdb && modules="${modules} xdb"
	use debug && myconf="${myconf} --enable-verbose-logging"

	econf \
		--sysconfdir=/etc/powerdns \
		--with-modules= \
		--with-dynmodules="${modules}" \
		--with-pgsql-includes=/usr/include \
		--with-pgsql-lib=/usr/$(get_libdir) \
		--with-mysql-lib=/usr/$(get_libdir) \
		--with-sqlite-lib=/usr/$(get_libdir) \
		$(use_enable static static-binaries) \
		$(use_enable recursor) \
		${myconf} \
		|| die "econf failed"
	emake -j1 || die "emake failed"

	if use doc
	then
		emake -C codedocs codedocs || die "emake codedocs failed"
	fi
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"

	mv "${D}"/etc/powerdns/pdns.conf{-dist,}

	# set defaults: setuid=pdns, setgid=pdns
	sed -i -e 's/^# set\([ug]\)id=$/set\1id=pdns/g' \
		"${D}"/etc/powerdns/pdns.conf

	doinitd "${FILESDIR}"/pdns

	if use recursor
	then
		doinitd "${FILESDIR}"/precursor
		insinto /etc/powerdns
		doins "${FILESDIR}"/recursor.conf
	fi

	dodoc ChangeLog README TODO
	use doc && dohtml -r codedocs/html/.
}

pkg_preinst() {
	enewgroup pdns
	enewuser pdns -1 -1 /var/empty pdns
}

pkg_postinst() {
	ewarn
	ewarn "ATTENTION: the config files have moved from /etc to /etc/powerdns!"
	ewarn
	einfo
	einfo "pdns now provides multiple instances support. You can create more instances"
	einfo "by symlinking the pdns init script to another name."
	einfo
	einfo "The name must be in the format pdns-<suffix> and PowerDNS will use the"
	einfo "/etc/powerdns/pdns-<suffix>.conf configuration file instead of the default."
	einfo
	einfo "Also all backends, except the bind and random backends, are now compiled as"
	einfo "loadable modules and must be loaded with load-modules= in the configuration"
	einfo "file."
	einfo
}
