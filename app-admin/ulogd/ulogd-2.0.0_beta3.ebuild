# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/ulogd/ulogd-2.0.0_beta3.ebuild,v 1.6 2010/01/25 18:56:12 armin76 Exp $

EAPI="1"

inherit eutils

MY_P=${P/_/}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A userspace logging daemon for netfilter/iptables related logging"
HOMEPAGE="http://netfilter.org/projects/ulogd/index.html"
SRC_URI="http://ftp.netfilter.org/pub/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc -sparc ~x86"
# sqlite not supported in ulogd-2 yet
IUSE="doc mysql postgres pcap" # sqlite

RDEPEND="net-firewall/iptables
	>=net-libs/libnfnetlink-0.0.39
	>=net-libs/libnetfilter_conntrack-0.0.95
	>=net-libs/libnetfilter_log-0.0.15
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-base )
	pcap? ( net-libs/libpcap )"
	#sqlite? ( dev-db/sqlite:3 )

DEPEND="${RDEPEND}
	sys-devel/autoconf:2.5
	doc? (
			app-text/linuxdoc-tools
			app-text/texlive-core
		 )"

pkg_setup() {
	enewgroup ulogd
	enewuser ulogd -1 -1 /var/log/ulogd ulogd
}

src_compile() {
	econf \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with pcap pcap /usr) \
		--without-sqlite3 #$(use_with sqlite sqlite3)

	emake || die "emake failed"

	if use doc ; then
		# build extra documentation files (.ps, .txt, .html, .dvi)

		# prevent access violations from generation of bitmap font files
		export VARTEXFONTS="${T}"
		emake -C doc || die "emake for docs failed"
	fi
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"

	doinitd "${FILESDIR}"/ulogd || die "doinitd failed"

	insinto /etc
	doins ulogd.conf || die "ulogd.conf installation failed"

	dodoc AUTHORS README

	if use doc ; then
		dohtml doc/ulogd.html
		dodoc doc/ulogd.dvi
		dodoc doc/ulogd.txt
		dodoc doc/ulogd.ps
	fi

	use mysql && dodoc doc/mysql-ulogd2.sql
	use postgres && dodoc doc/pgsql-ulogd2.sql
	#use sqlite && dodoc doc/sqlite3.table

	# install logrotate config
	insinto /etc/logrotate.d
	newins ulogd.logrotate ulogd || die "logrotate config failed"

	doman ulogd.8 || die
}

pkg_postinst() {
	chown root:ulogd "${ROOT}"/etc/ulogd.conf
	chmod 640        "${ROOT}"/etc/ulogd.conf
}
