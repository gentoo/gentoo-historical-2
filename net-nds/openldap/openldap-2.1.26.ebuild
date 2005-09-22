# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/openldap/openldap-2.1.26.ebuild,v 1.17 2005/09/22 19:57:41 robbat2 Exp $

inherit eutils

DESCRIPTION="LDAP suite of application and development tools"
HOMEPAGE="http://www.OpenLDAP.org/"
SRC_URI="mirror://openldap/openldap-release/${P}.tgz"

LICENSE="OPENLDAP"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha amd64 ~mips ia64"
IUSE="berkdb crypt debug gdbm ipv6 kerberos odbc perl readline samba sasl slp ssl tcpd"

DEPEND=">=sys-libs/ncurses-5.1
	>=sys-apps/sed-4
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	readline? ( >=sys-libs/readline-4.1 )
	sasl? ( >=dev-libs/cyrus-sasl-2.1.7-r3 )
	kerberos? ( >=app-crypt/mit-krb5-1.2.6 )
	odbc? ( dev-db/unixODBC )
	slp? ( >=net-libs/openslp-1.0 )
	perl? ( >=dev-lang/perl-5.6 )
	samba? ( >=dev-libs/openssl-0.9.6 )"

# if USE=berkdb
#	pull in sys-libs/db
# else if USE=gdbm
#	pull in sys-libs/gdbm
# else
#	pull in sys-libs/db
DEPEND="${DEPEND}
	berkdb? ( >=sys-libs/db-4.1.25_p1-r3 )
	!berkdb? (
		gdbm? ( >=sys-libs/gdbm-1.8.0 )
		!gdbm? ( >=sys-libs/db-4.1.25_p1-r3 )
	)"

pkg_preinst() {
	enewgroup ldap 439
	enewuser ldap 439 -1 /usr/lib/openldap ldap
}

src_unpack() {
	unpack ${A}

	# upstream has merged this
	## fix a sed issue
	## we do NOT use epatch here as the patch is against configure.in
	## and I want to patch configure instead
	##patch ${S}/configure ${FILESDIR}/${PN}-2.1.22-perlsedfoo.patch

	# According to MDK, the link order needs to be changed so that
	# on systems w/ MD5 passwords the system crypt library is used
	# (the net result is that "passwd" can be used to change ldap passwords w/
	#  proper pam support)
	sed -ie 's/$(SECURITY_LIBS) $(LDIF_LIBS) $(LUTIL_LIBS)/$(LUTIL_LIBS) $(SECURITY_LIBS) $(LDIF_LIBS)/' ${S}/servers/slapd/Makefile.in

	#cd ${S}
	#epatch ${FILESDIR}/${PN}-2.1.26-perlfix.patch
	sed -ie '49 a#include <XSUB.h>' ${S}/servers/slapd/back-perl/perl_back.h
}

src_compile() {
	local myconf

	# enable debugging to syslog
	use debug && myconf="${myconf} --enable-debug"
	myconf="${myconf} --enable-syslog"

	# enable slapd/slurpd servers
	myconf="${myconf} --enable-ldap"
	myconf="${myconf} --enable-slapd --enable-slurpd"

	myconf="${myconf} `use_enable crypt`"
	myconf="${myconf} `use_enable ipv6`"
	myconf="${myconf} `use_with sasl cyrus-sasl` `use_enable sasl spasswd`"
	myconf="${myconf} `use_with kerberos` `use_enable kerberos kpasswd`"
	myconf="${myconf} `use_with readline`"
	myconf="${myconf} `use_with ssl tls` `use_with samba lmpasswd`"
	myconf="${myconf} `use_enable tcpd wrappers`"
	myconf="${myconf} `use_enable odbc sql`"
	myconf="${myconf} `use_enable perl`"
	myconf="${myconf} `use_enable slp`"

	myconf="${myconf} --enable-ldbm"
	myconf_berkdb='--enable-bdb --with-ldbm-api=berkeley'
	myconf_gdbm='--disable-bdb --with-ldbm-api=gdbm'
	if use berkdb; then
		einfo "Using Berkeley DB for local backend"
		myconf="${myconf} ${myconf_berkdb}"
	elif use gdbm; then
		einfo "Using GDBM for local backend"
		myconf="${myconf} ${myconf_gdbm}"
	else
		ewarn "Neither gdbm or berkdb USE flags present, falling back to"
		ewarn "Berkeley DB for local backend"
		myconf="${myconf} ${myconf_berkdb}"
	fi

	# alas, for BSD only
	#myconf="${myconf} --with-fetch"

	myconf="${myconf} --enable-dynamic --enable-modules"
	myconf="${myconf} --enable-rewrite --enable-rlookups"
	myconf="${myconf} --enable-passwd --enable-phonetic"
	myconf="${myconf} --enable-dnssrv --enable-ldap"
	myconf="${myconf} --enable-meta --enable-monitor"
	myconf="${myconf} --enable-null --enable-shell"
	myconf="${myconf} --enable-local --enable-proctitle"

	# disabled options
	# --with-bdb-module=dynamic
	# --enable-dnsserv --with-dnsserv-module=dynamic

	econf \
		--libexecdir=/usr/lib/openldap \
		${myconf} || die "configure failed"

	make depend || die "make depend failed"
	make || die "make failed"
	#cd tests ; make || die "make tests failed"

}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc ANNOUNCEMENT CHANGES COPYRIGHT README LICENSE
	docinto rfc ; dodoc doc/rfc/*.txt

	# make state directories
	for x in data slurp ldbm; do
		keepdir /var/lib/openldap-${x}
		fowners ldap:ldap /var/lib/openldap-${x}
		fperms 0700 /var/lib/openldap-${x}
	done

	# manually remove /var/tmp references in .la
	# because it is packaged with an ancient libtool
	for x in ${D}/usr/lib/lib*.la; do
		sed -i -e "s:-L${S}[/]*libraries::" ${x}
	done

	# change slapd.pid location in configuration file
	keepdir /var/run/openldap
	fowners ldap:ldap /var/run/openldap
	fperms 0755 /var/run/openldap
	sed -i -e "s:/var/lib/slapd.pid:/var/run/openldap/slapd.pid:" ${D}/etc/openldap/slapd.conf
	sed -i -e "s:/var/lib/slapd.pid:/var/run/openldap/slapd.pid:" ${D}/etc/openldap/slapd.conf.default
	sed -i -e "s:/var/lib/slapd.args:/var/run/openldap/slapd.args:" ${D}/etc/openldap/slapd.conf
	sed -i -e "s:/var/lib/slapd.args:/var/run/openldap/slapd.args:" ${D}/etc/openldap/slapd.conf.default
	fowners root:ldap /etc/openldap/slapd.conf
	fperms 0640 /etc/openldap/slapd.conf
	fowners root:ldap /etc/openldap/slapd.conf.default
	fperms 0640 /etc/openldap/slapd.conf.default

	# install our own init scripts
	exeinto /etc/init.d
	newexe ${FILESDIR}/2.0/slapd slapd
	newexe ${FILESDIR}/2.0/slurpd slurpd
	insinto /etc/conf.d
	newins ${FILESDIR}/2.0/slapd.conf slapd

	# install MDK's ssl cert script
	if use ssl || use samba; then
		dodir /etc/openldap/ssl
		exeinto /etc/openldap/ssl
		doexe ${FILESDIR}/gencert.sh
	fi
}

pkg_postinst() {
	if use ssl; then
		# make a self-signed ssl cert (if there isn't one there already)
		if [ ! -e /etc/openldap/ssl/ldap.pem ]
		then
			cd /etc/openldap/ssl
			yes "" | sh gencert.sh
			chmod 640 ldap.pem
			chown root:ldap ldap.pem
		else
			einfo "An LDAP cert already appears to exist, not creating"
		fi
	fi

	# Since moving to running openldap as user ldap there are some
	# permissions problems with directories and files.
	# Let's make sure these permissions are correct.
	chown ldap:ldap /var/run/openldap
	chmod 0755 /var/run/openldap
	chown root:ldap /etc/openldap/slapd.conf
	chmod 0640 /etc/openldap/slapd.conf
	chown root:ldap /etc/openldap/slapd.conf.default
	chmod 0640 /etc/openldap/slapd.conf.default
	chown ldap:ldap /var/lib/openldap-{data,ldbm,slurp}

	# notes from bug #41297, bug #41039
	ewarn "If you are upgrading from OpenLDAP 2.0, major changes have occured:"
	ewarn "- bind_anon_dn is now disabled by default for security"
	ewarn "  add 'allow bind_anon_dn' to your config for the old behavior."
	ewarn "- Default schemas have changed, you should slapcat your entire DB to"
	ewarn "  a file, delete your DB, and then slapadd it again. Alternatively"
	ewarn "  you can try slapindex which should work in almost all cases. Be"
	ewarn "  sure to check the permissions on the database files afterwards!"
	if use ssl; then
		ewarn "- Self-signed SSL certificates are treated harshly by OpenLDAP 2.1"
		ewarn "  add 'TLS_REQCERT never' if you want to use them."
	fi
}
