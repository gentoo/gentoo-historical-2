# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/ulogd/ulogd-1.24-r1.ebuild,v 1.1 2009/08/09 06:23:59 wormo Exp $

EAPI="1"

inherit eutils flag-o-matic autotools

DESCRIPTION="A userspace logging daemon for netfilter/iptables related logging"
HOMEPAGE="http://netfilter.org/projects/ulogd/index.html"
SRC_URI="http://ftp.netfilter.org/pub/ulogd/${P}.tar.bz2
	mirror://gentoo/${PN}-glsa-200805.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc -sparc ~x86"
IUSE="mysql postgres sqlite"

DEPEND="net-firewall/iptables
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-server )
	sqlite? ( dev-db/sqlite:3 )"
RDEPEND="${DEPEND}
	net-libs/libpcap"

pkg_setup() {
	enewgroup ulogd
	enewuser ulogd -1 -1 /var/log/ulogd ulogd
}

src_unpack() {
	unpack ${A} || die "unpack failed"
	cd "${S}" || die "dir ${S} not found"

	# enables logfiles over 2G (#74924)
	append-lfs-flags

	epatch "${DISTDIR}/${PN}-glsa-200805.patch.bz2"

	# switch plugin makefiles to use $(CC) instead of $(LD) for linking
	# (prevents build from choking on stuff like "LDFLAGS=-Wl,O1")
	for p in pgsql sqlite3 extensions mysql pcap ; do
		f=$p/Makefile.in
		sed -i -e 's/$(LD)/$(CC) -nostartfiles/' $f || die "failed to update $f"
	done

	ewarn "Regenerating build system (this may take a bit)..."
	eautoconf || die "Autoreconf failed"
	econf \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with sqlite sqlite3) \
		|| die "configure failed"

	# Configure uses incorrect syntax for ld
	use mysql && sed -i -e "s:-Wl,::g;s:-rdynamic::g" Rules.make
}

src_compile() {
	# not parallel make safe: bug #128976
	emake -j1 || die "make failed"
}

src_install() {
	# the Makefile seems to be "broken" -
	# it relies on the existance of /usr, /etc ..
	dodir /usr/sbin

	make DESTDIR="${D}" install || die "install failed"

	newinitd "${FILESDIR}"/ulogd-0.98 ulogd
	local UsedServices="use"
	use mysql  && UsedServices+=" mysql"
	use postgres && UsedServices+=" postgresql"
	if  [[ ${UsedServices} = "use" ]]; then
	    UsedServices=""
	fi
	sed -i -e "s:use mysql:${UsedServices}:g" "${D}/etc/init.d/ulogd" || die "sed failed"

	dodoc README AUTHORS Changes
	cd doc/
	dodoc ulogd.txt ulogd.a4.ps

	use mysql && dodoc mysql.table mysql.table.ipaddr-as-string
	use postgres && dodoc pgsql.table
	use sqlite && dodoc sqlite3.table

	dohtml ulogd.html
}

pkg_postinst() {
	chown root:ulogd /etc/ulogd.conf
	chmod 640        /etc/ulogd.conf
}
