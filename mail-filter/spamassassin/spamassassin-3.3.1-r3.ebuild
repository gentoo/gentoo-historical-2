# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/spamassassin/spamassassin-3.3.1-r3.ebuild,v 1.3 2010/09/27 21:28:22 hwoarang Exp $

EAPI="2"

inherit perl-module toolchain-funcs eutils

MY_P=Mail-SpamAssassin-${PV//_/-}
S=${WORKDIR}/${MY_P}
DESCRIPTION="SpamAssassin is an extensible email filter which is used to identify spam."
HOMEPAGE="http://spamassassin.apache.org/"
SRC_URI="http://apache.osuosl.org/spamassassin/source/${MY_P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc64 ~sparc ~x86"
# need keyword request for Mail-SPF ppc ppc64
IUSE="berkdb qmail ssl doc ldap mysql postgres sqlite ipv6"

DEPEND=">=dev-lang/perl-5.8.8-r8
	virtual/perl-MIME-Base64
	>=virtual/perl-PodParser-1.32
	virtual/perl-Storable
	virtual/perl-Time-HiRes
	>=dev-perl/HTML-Parser-3.43
	>=dev-perl/Mail-DKIM-0.37
	>=dev-perl/Net-DNS-0.53
	dev-perl/Digest-SHA1
	dev-perl/libwww-perl
	>=virtual/perl-Archive-Tar-1.26
	app-crypt/gnupg
	>=virtual/perl-IO-Zlib-1.04
	>=dev-util/re2c-0.12.0
	dev-perl/Mail-SPF
	dev-perl/NetAddr-IP
	ssl? (
		dev-perl/IO-Socket-SSL
		dev-libs/openssl
	)
	berkdb? (
		virtual/perl-DB_File
	)
	ldap? ( dev-perl/perl-ldap )
	mysql? (
		dev-perl/DBI
		dev-perl/DBD-mysql
	)
	postgres? (
		dev-perl/DBI
		dev-perl/DBD-Pg
	)
	sqlite? (
		dev-perl/DBI
		dev-perl/DBD-SQLite
	)
	ipv6? (
		dev-perl/IO-Socket-INET6
	)"

PATCHES=( "${FILESDIR}/${P}-PERL-5-12.patch" )

RDEPEND="${DEPEND}"

# - Disable tests as they will fail
# - Please see http://www.cpantesters.org/distro/M/Mail-SpamAssassin.html#Mail-SpamAssassin-3.3.1
# - for more info, upstream problem not specific to Gentoo
SRC_TEST="skip"

src_configure() {
	# - Set SYSCONFDIR explicitly so we can't get bitten by bug 48205 again
	#	(just to be sure, nobody knows how it could happen in the first place).
	myconf="SYSCONFDIR=/etc DATADIR=/usr/share/spamassassin"

	# If ssl is enabled, spamc can be built with ssl support
	if use ssl; then
		myconf+=" ENABLE_SSL=yes"
	else
		myconf+=" ENABLE_SSL=no"
	fi

	# Set the path to the Perl executable explictly.  This will be used to
	# create the initial sharpbang line in the scripts and might cause
	# a versioned app name end in there, see
	# <http://bugs.gentoo.org/show_bug.cgi?id=62276>
	myconf+=" PERL_BIN=/usr/bin/perl"

	# Add Gentoo tag to make it easy for the upstream devs to spot
	# possible modifications or patches.
	#version_tag="g${PV:6}${PR}"
	#version_str="${PV//_/-}-${version_tag}"

	# Create the Gentoo config file before Makefile.PL is called so it
	# is copied later on.
	#echo "version_tag ${version_tag}" > rules/11_gentoo.cf

	# Setting the following env var ensures that no questions are asked.
	perl-module_src_configure
	# Configure spamc
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" spamc/Makefile || die "emake failed"
}

src_compile() {
	export PERL_MM_USE_DEFAULT=1

	# Now compile all the stuff selected.
	perl-module_src_compile

	if use qmail; then
		emake spamc/qmail-spamc || die "building qmail-spamc emake failed"
	fi

}

src_install () {
	perl-module_src_install

	# Create the stub dir used by sa-update and friends
	dodir /var/lib/spamassassin || die

	# Move spamd to sbin where it belongs.
	dodir /usr/sbin
	mv "${D}"/usr/bin/spamd "${D}"/usr/sbin/spamd  || die "move spamd failed"

	if use qmail; then
		dobin spamc/qmail-spamc || die
	fi

	dosym /etc/mail/spamassassin /etc/spamassassin || die

	# Disable plugin by default
	sed -i -e 's/^loadplugin/\#loadplugin/g' "${D}"/etc/mail/spamassassin/init.pre || die

	# Add the init and config scripts.
	newinitd "${FILESDIR}"/3.3.1-spamd.init spamd || die
	newconfd "${FILESDIR}"/3.0.0-spamd.conf spamd || die

	use postgres && \
		sed -i -e 's:@USEPOSTGRES@::' "${D}/etc/init.d/spamd" || \
		sed -i -e '/@USEPOSTGRES@/d' "${D}/etc/init.d/spamd"

	use mysql && \
		sed -i -e 's:@USEMYSQL@::' "${D}/etc/init.d/spamd" || \
		sed -i -e '/@USEMYSQL@/d' "${D}/etc/init.d/spamd"

	dodoc NOTICE TRADEMARK CREDITS INSTALL.VMS UPGRADE USAGE \
		sql/README.bayes sql/README.awl procmailrc.example sample-nonspam.txt \
		sample-spam.txt spamassassin.spec spamd/PROTOCOL spamd/README.vpopmail \
		spamd-apache2/README.apache || die

	# Rename some docu files so they don't clash with others
	newdoc spamd/README README.spamd || die
	newdoc sql/README README.sql || die
	newdoc ldap/README README.ldap || die

	if use qmail; then
		dodoc spamc/README.qmail || die
	fi

	cp "${FILESDIR}"/secrets.cf "${D}"/etc/mail/spamassassin/secrets.cf.example || die
	fperms 0400 /etc/mail/spamassassin/secrets.cf.example

	cat <<EOF > "${T}/local.cf.example"
# Sensitive data, such as database connection info, should be stored in
# /etc/mail/spamassassin/secrets.cf with appropriate permissions
EOF

	insinto /etc/mail/spamassassin/
	doins "${T}/local.cf.example" || die
}

pkg_postinst() {
	perl-module_pkg_postinst
	elog "If you plan on using the -u flag to spamd, please read the notes"
	elog "in /etc/conf.d/spamd regarding the location of the pid file.\n"
	elog "If you build ${PN} with optional dependancy support,"
	elog "you can enable them in /etc/mail/spamassassin/init.pre\n"
	elog "You need to configure your database to be able to use Bayes filter"
	elog "with database backend, otherwise it will still use (and need) the"
	elog "Berkeley DB support."
	elog "Look at the sql/README.bayes file in the documentation directory"
	elog "for how to configure it.\n"
	elog "If you plan to use Vipul's Razor, note that versions up to and"
	elog "including version 2.82 include a bug that will slow down the entire"
	elog "perl interpreter.  Version 2.83 or later fixes this."
	elog "If you do not plan to use this plugin, be sure to comment out"
	elog "its loadplugin line in /etc/mail/spamassassin/v310.pre.\n"
	elog "The DKIM plugin is now enabled by default for new installs,"
	elog "if the perl module Mail::DKIM is installed."
	elog "However, installation of SpamAssassin will not overwrite existing"
	elog ".pre configuration files, so to use DKIM when upgrading from a"
	elog "previous release that did not use DKIM, a directive:\n"
	elog "loadplugin Mail::SpamAssassin::Plugin::DKIM"
	elog "will need to be uncommented in file 'v312.pre', or added"
	elog "to some other .pre file, such as local.pre.\n"
	ewarn "Rules are no longer included with SpamAssassin out of the box".
	ewarn "You will need to immediately run sa-update, or download"
	ewarn "the additional rules .tgz package and run sa-update --install"
	ewarn "with it, to get a ruleset.\n"
	elog "If when you run sa-update and receive a GPG validation error."
	elog "Then you need to import an updated sa-update key."
	elog "sa-update --import /usr/share/spamassassin/sa-update-pubkey.txt\n"
}
