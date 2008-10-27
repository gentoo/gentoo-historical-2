# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/qpsmtpd/qpsmtpd-0.43_rc2_pre955.ebuild,v 1.1 2008/10/27 18:51:55 jokey Exp $

inherit eutils subversion
REVNO=${PV/0.43_rc2_pre}
DESCRIPTION="qpsmtpd is a flexible smtpd daemon written in Perl"
HOMEPAGE="http://smtpd.develooper.com"
ESVN_REPO_URI="http://svn.perl.org/qpsmtpd/trunk@${REVNO}"
ESVN_PROJECT="qpsmtpd"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE="postfix async ipv6 syslog"

RDEPEND=">=dev-lang/perl-5.8.0
	dev-perl/Net-DNS
	virtual/perl-MIME-Base64
	dev-perl/MailTools
	async? ( dev-perl/IPC-Shareable
			dev-perl/Socket6
			dev-perl/Danga-Socket
			dev-perl/ParaDNS
	)
	ipv6? ( dev-perl/IO-Socket-INET6 )
	syslog? ( virtual/perl-Sys-Syslog )
	virtual/inetd"

pkg_setup() {
	enewgroup smtpd
	local additional_groups
	if use postfix; then
		additional_groups="${additional_groups},postdrop"
	fi
	enewuser smtpd -1 -1 /var/spool/qpsmtpd smtpd${additional_groups}
}

src_unpack() {
	subversion_src_unpack
	epatch "${FILESDIR}"/${PN}-0.40-badhelo_disconnect.patch
	epatch "${FILESDIR}"/${PN}-0.40-badrcptto_allowrelay.patch
	epatch "${FILESDIR}"/${PN}-0.43-peer_hooks.patch
	epatch "${FILESDIR}"/${PN}-0.40-clamd_conf.patch
}

src_compile() {
	perl Makefile.PL PREFIX=/usr || die "Running Makefile.PL failed"
	emake || die "make failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/qpsmtpd.xinetd qpsmtpd

	dodir /usr/share/qpsmtpd
	cp -Rf plugins "${D}"/usr/share/qpsmtpd/

	diropts -m 0755 -o smtpd -g smtpd
	dodir /var/spool/qpsmtpd
	keepdir /var/spool/qpsmtpd

	dodir /etc/qpsmtpd
	insinto /etc/qpsmtpd
	doins config.sample/*

	echo "/usr/share/qpsmtpd/plugins" > "${D}"/etc/qpsmtpd/plugin_dirs
	echo "/var/spool/qpsmtpd" > "${D}"/etc/qpsmtpd/spool_dir
	if use syslog; then
		echo "logging/syslog loglevel LOGINFO priority LOG_NOTICE" > "${D}"/etc/qpsmtpd/logging
	else
		diropts -m 0755 -o smtpd -g smtpd
		dodir /var/log/qpsmtpd
		keepdir /var/log/qpsmtpd
		echo "logging/file loglevel LOGINFO /var/log/qpsmtpd/%Y-%m-%d" > "${D}"/etc/qpsmtpd/logging
	fi

	newenvd "${FILESDIR}"/qpsmtpd.envd 99qpsmtpd

	newconfd "${FILESDIR}"/qpsmtpd.confd qpsmtpd || die "Installing conf.d file"
	newinitd "${FILESDIR}"/qpsmtpd.initd qpsmtpd || die "Installing init.d file"

	dodoc CREDITS Changes README README.authentication README.logging README.plugins STATUS
}
