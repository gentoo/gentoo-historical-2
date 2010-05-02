# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/munin/munin-1.4.3.ebuild,v 1.4 2010/05/02 22:33:29 robbat2 Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Munin Server Monitoring Tool"
HOMEPAGE="http://munin.projects.linpro.no/"
SRC_URI="mirror://sourceforge/munin/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~sparc ~x86"
IUSE="doc minimal irc mysql postgres ssl"

# Upstream's listing of required modules is NOT correct!
# Some of the postgres plugins use DBD::Pg, while others call psql directly.
# The mysql plugins use mysqladmin directly.
DEPEND_COM="dev-lang/perl
			sys-process/procps
			ssl? ( dev-perl/Net-SSLeay )
			mysql? ( virtual/mysql )
			postgres? ( dev-perl/DBD-Pg virtual/postgresql-base )
			irc? ( dev-perl/Net-IRC )
			dev-perl/DateManip
			dev-perl/Log-Log4perl
			dev-perl/Net-CIDR
			dev-perl/Net-Netmask
			dev-perl/Net-SNMP
			dev-perl/libwww-perl
			dev-perl/net-server
			dev-perl/DBI
			virtual/perl-Digest-MD5
			virtual/perl-Getopt-Long
			virtual/perl-MIME-Base64
			virtual/perl-Storable
			virtual/perl-Text-Balanced
			virtual/perl-Time-HiRes
			!minimal? ( dev-perl/HTML-Template
						net-analyzer/rrdtool[perl] )"
			# Sybase isn't supported in Gentoo
			#munin-sybase? (	 dev-perl/DBD-Sybase )

# Keep this seperate, as previous versions have had other deps here
DEPEND="${DEPEND_COM}"
RDEPEND="${DEPEND_COM}
		!minimal? ( virtual/cron )"

pkg_setup() {
	enewgroup munin
	enewuser munin 177 -1 /var/lib/munin munin
}

src_prepare() {
	# upstream needs a lot of DESTDIR loving
	# and Gentoo location support
	epatch "${FILESDIR}"/${PN}-1.4.3-Makefile.patch
	# Fix noise in the plugins
	epatch "${FILESDIR}"/${PN}-1.4.3-plugin-cleanup.patch

	# Bug #195964, fix up conntrack
	# Patch modified as it has only been partially taken up by upstream
	epatch "${FILESDIR}"/${PN}-1.4.3-fw_conntrack_plugins.patch

	epatch "${FILESDIR}"/${P}-ping6_fix.patch
}

src_compile() {
	emake -j 1 build build-man || die "build/build-man failed"
	if use doc; then
		emake -j 1 build-doc || die "build-doc failed"
	fi

	#Ensure TLS is disabled if built without SSL
	if ! use ssl; then
		echo "tls disabled" >> ${S}/build/node/munin-node.conf \
			|| die "Fixing munin-node.conf Failed!"
		echo "tls disabled" >> ${S}/build/master/munin.conf \
			|| die "Fixing munin.conf Failed!"
	fi

}

src_install() {
	local dirs
	dirs="/var/log/munin/ /var/lib/munin/"
	dirs="${dirs} /var/lib/munin/plugin-state/"
	dirs="${dirs} /var/run/munin/plugin-state/"
	dirs="${dirs} /var/run/munin/spool/"
	dirs="${dirs} /etc/munin/plugin-conf.d/"
	dirs="${dirs} /etc/munin/munin-conf.d/"
	dirs="${dirs} /etc/munin/plugins/"
	keepdir ${dirs}

	emake -j 1 DESTDIR="${D}" install || die "install failed"
	fowners munin:munin ${dirs} || die

	insinto /etc/munin/plugin-conf.d/
	newins "${FILESDIR}"/${PN}-1.3.2-plugins.conf munin-node || die

	# make sure we've got everything in the correct directory
	insinto /var/lib/munin
	newins "${FILESDIR}"/${PN}-1.3.3-crontab crontab || die
	newinitd "${FILESDIR}"/munin-node_init.d_1.3.3-r1 munin-node || die
	newconfd "${FILESDIR}"/munin-node_conf.d_1.3.3-r1 munin-node || die
	dodoc README ChangeLog INSTALL logo.eps logo.svg build/resources/apache* \
		|| die

	# bug 254968
	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/logrotate.d-munin munin || die
}

pkg_config() {
	einfo "Press enter to install the default crontab for the munin master"
	einfo "installation from /var/lib/munin/crontab"
	einfo "If you have a large site, you may wish to customize it."
	read
	# dcron is very fussy about syntax
	# the following is the only form that works in BOTH dcron and vixie-cron
	crontab - -u munin </var/lib/munin/crontab
}

pkg_postinst() {
	elog "Please follow the munin documentation to set up the plugins you"
	elog "need, afterwards start munin-node via /etc/init.d/munin-node."
	elog "To have munin's cronjob automatically configured for you if this is"
	elog "your munin master installation, please:"
	elog "emerge --config net-analyzer/munin"
	elog ""
	elog "Please note that the crontab has undergone some modifications"
	elog "since 1.3.2, and you should update to it!"
}
