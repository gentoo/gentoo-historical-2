# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cyrus-sasl/cyrus-sasl-2.1.19.ebuild,v 1.2 2004/07/21 23:56:52 langthang Exp $

inherit eutils flag-o-matic gnuconfig

DESCRIPTION="The Cyrus SASL (Simple Authentication and Security Layer)"
HOMEPAGE="http://asg.web.cmu.edu/sasl/"
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/${P}.tar.gz"

LICENSE="as-is"
SLOT="2"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~arm ~hppa ~amd64 ~ia64 ~s390 ~ppc64"
IUSE="berkdb gdbm ldap mysql postgres kerberos static ssl java pam"

RDEPEND="virtual/libc
	>=sys-libs/db-3.2
	gdbm? ( >=sys-libs/gdbm-1.8.0 )
	ldap? ( >=net-nds/openldap-2.0.25 )
	mysql? ( >=dev-db/mysql-3.23.51 )
	postgres? ( >=dev-db/postgresql-7.2 )
	pam? ( >=sys-libs/pam-0.75 )
	ssl? ( >=dev-libs/openssl-0.9.6d )
	kerberos? ( virtual/krb5 )
	java? ( virtual/jdk )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	>=sys-devel/autoconf-2.58
	sys-devel/automake
	sys-devel/libtool"

pkg_setup() {
	if use gdbm && use berkdb; then
		echo
		eerror "You have both \"gdbm\" and \"berkdb\" in your USE flags."
		eerror "please choose only one for your SASLdb database backend."
		echo

		has_version ">=sys-apps/portage-2.0.50" && (
		einfo "It would be best practice to add the set of USE flags that you use for this"
		einfo "package to the file: /etc/portage/package.use. Example:"
		einfo "\`echo \"dev-libs/cyrus-sasl gdbm -berkdb\" >> /etc/portage/package.use\`"
		einfo "to build cyrus-sasl with GNU database as your SASLdb backend."
		)

		exit 1
	fi
	echo
	einfo "This version include a "-r" option for saslauthd to instruct it to reassemble"
	einfo "realm and username into a username of "user@realm" form."
	echo
	einfo "If you are still using postfix->sasl->saslauthd->pam->mysql for"
	einfo "authentication, please edit /etc/conf.d/saslauthd to read:"
	einfo "SASLAUTHD_OPTS=\"\${SASLAUTH_MECH} -a pam -r\""
	einfo "Don't forget to restart the service: \`/etc/init.d/saslauthd restart\`."
	echo
	einfo "Pause 30 seconds before continuing."
	sleep 30
}

src_unpack() {
	unpack ${A} && cd "${S}"


	# Fix default port name for rimap auth mechanism.
	sed -e '/define DEFAULT_REMOTE_SERVICE/s:imap:imap2:' \
		-i saslauthd/auth_rimap.c || die "sed failed"

	# DB4 detection and versioned symbols.
	epatch "${FILESDIR}/cyrus-sasl-2.1.18-db4.patch"

	# Add configdir support.
	epatch "${FILESDIR}/${P}-configdir.patch"

	# Fix include path for newer PostgreSQL versions.
	epatch "${FILESDIR}/cyrus-sasl-2.1.17-pgsql-include.patch"

	# Add setuid/setgid check for SASL_PATH
	epatch "${FILESDIR}/${P}-sasl-path-fix.patch"

	# Recreate configure.
	export WANT_AUTOCONF="2.5"
	rm -f configure config.h.in saslauthd/configure
	ebegin "Recreating configure"
	aclocal -I cmulocal -I config && autoheader && autoconf || \
		die "recreate configure failed"
	eend $?

	cd "${S}/saslauthd"
	ebegin "Recreating saslauthd/configure"
	aclocal -I ../cmulocal -I ../config && autoheader && autoconf || \
		die "recreate configure failed"
	eend $?
}

src_compile() {
	local myconf="--enable-login --enable-ntlm --disable-krb4 --disable-otp"
	myconf="${myconf} `use_enable static`"
	myconf="${myconf} `use_with ssl openssl`"
	myconf="${myconf} `use_with pam`"
	myconf="${myconf} `use_with ldap`"
	myconf="${myconf} `use_enable kerberos gssapi`"
	myconf="${myconf} `use_with mysql` `use_enable mysql sql`"
	myconf="${myconf} `use_with postgres pgsql` `use_enable postgres sql`"
	myconf="${myconf} `use_enable java` `use_with java javahome ${JAVA_HOME}`"

	if use mysql || use postgres ; then
		myconf="${myconf} --enable-sql"
	else
		myconf="${myconf} --disable-sql"
	fi
	if use gdbm ; then
		einfo "build with GNU DB as database backend for your SASLdb."
		myconf="${myconf} --with-dblib=gdbm"
	elif use berkdb ; then
		einfo "build with Berkeley DB as database backend for your SASLdb."
		myconf="${myconf} --with-dblib=berkeley"
	else
		einfo "build without SASLdb support"
		myconf="${myconf} --with-dblib=none"
	fi

	# Compaq-sdk checks for -D_REENTRANT and -pthread takes care the cpp stuff.
	use alpha && append-flags -D_REENTRANT -pthread

	# Detect mips systems properly.
	gnuconfig_update

	econf \
		--with-saslauthd=/var/lib/sasl2 \
		--with-pwcheck=/var/lib/sasl2 \
		--with-configdir=/etc/sasl2 \
		--with-plugindir=/usr/lib/sasl2 \
		--with-dbpath=/etc/sasl2/sasldb2 \
		${myconf} || die "econf failed"

	# Parallel build doesn't work.
	emake -j1 || die "compile problem"
}

src_install () {
	einstall
	keepdir /var/lib/sasl2 /etc/sasl2

	# Generate an empty sasldb2 with correct permissions.
	LD_OLD="${LD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH="${D}/usr/lib" SASL_PATH="${D}/usr/lib/sasl2"
	echo "p" | "${D}/usr/sbin/saslpasswd2" -f "${D}/etc/sasl2/sasldb2" -p login
	"${D}/usr/sbin/saslpasswd2" -f "${D}/etc/sasl2/sasldb2" -d login
	export LD_LIBRARY_PATH="${LD_OLD}"
	chown root:mail "${D}/etc/sasl2/sasldb2"
	chmod 0640 "${D}/etc/sasl2/sasldb2"

	dodoc AUTHORS COPYING ChangeLog NEWS README doc/TODO doc/*.txt
	newdoc pwcheck/README README.pwcheck
	dohtml doc/*.html

	docinto examples
	dodoc sample/{*.[ch],Makefile}

	docinto saslauthd
	dodoc saslauthd/{AUTHORS,COPYING,ChangeLog,LDAP_SASLAUTHD,NEWS,README}

	if use pam ; then
		insinto /etc/pam.d
		newins "${FILESDIR}/saslauthd.pam" saslauthd
	fi

	exeinto /etc/init.d
	newexe "${FILESDIR}/pwcheck.rc6" pwcheck
	newexe "${FILESDIR}/saslauthd2.rc6" saslauthd
	insinto /etc/conf.d
	newins "${FILESDIR}/saslauthd-${PV}.conf" saslauthd
}
