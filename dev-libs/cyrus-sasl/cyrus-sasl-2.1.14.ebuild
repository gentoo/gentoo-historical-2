# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cyrus-sasl/cyrus-sasl-2.1.14.ebuild,v 1.8 2003/08/06 08:06:53 vapier Exp $

inherit eutils

S=${WORKDIR}/${P}
DESCRIPTION="The Cyrus SASL (Simple Authentication and Security Layer)"
HOMEPAGE="http://asg.web.cmu.edu/sasl/"
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/${P}.tar.gz"
LICENSE="as-is"
SLOT="2"
KEYWORDS="x86 ppc sparc hppa amd64"
IUSE="gdbm berkdb ldap mysql kerberos static ssl java pam" # otp krb4

RDEPEND=">=sys-libs/db-3.2
	>=sys-libs/pam-0.75
	>=dev-libs/openssl-0.9.6d
	gdbm? ( >=sys-libs/gdbm-1.8.0 )
	berkdb? ( >=sys-libs/db-3.2.9 )
	ldap? ( >=net-nds/openldap-2.0.25 )
	mysql? ( >=dev-db/mysql-3.23.51 )
	kerberos? ( >=app-crypt/mit-krb5-1.2.6 )
	java? ( virtual/jdk )"
DEPEND="${RDEPEND}
	sys-devel/libtool
	sys-devel/autoconf
	sys-devel/automake"

src_unpack() {
	unpack ${A}; cd ${S}

	# Fix for compiling with kerberos enabled
	# http://asg.web.cmu.edu/archive/message.php?mailbox=archive.cyrus-sasl&msg=3912
	epatch ${FILESDIR}/2.1.14-kerberos.patch

	# Fix for compatibility with MySQL 4.x
	# http://bugzilla.andrew.cmu.edu/cgi-bin/cvsweb.cgi/src/sasl/plugins/mysql.c.diff?r1=1.10&r2=1.11
	epatch ${FILESDIR}/2.1.14-mysql.patch

	# Updated the cyrus-sasl-2.1.12-db4.patch
	epatch ${FILESDIR}/2.1.14-db4.patch
}

src_compile() {
	libtoolize --copy --force
	aclocal -I config -I cmulocal || die
	autoheader || die
	automake -a --foreign || die
	autoconf || die
	autoconf saslauthd/configure.in > saslauthd/configure || die
	chmod +x saslauthd/configure || die

	local myconf
	myconf="--with-gnu-ld --enable-login --enable-ntlm"

	use static && myconf="${myconf} --enable-static"

	use ssl && myconf="${myconf} --with-openssl" \
		|| myconf="${myconf} --without-openssl"

	use ldap && myconf="${myconf} --with-ldap" \
		|| myconf="${myconf} --without-ldap"

	use mysql && myconf="${myconf} --with-mysql" \
		|| myconf="${myconf} --without-mysql"

	if use berkdb; then
		myconf="${myconf} --with-dblib=berkeley"
	elif use gdbm; then
		myconf="${myconf} --with-dblib=gdbm --with-gdbm=/usr"
	else
		myconf="${myconf} --with-dblib=berkeley"
	fi

	use kerberos && myconf="${myconf} --enable-gssapi" \
		|| myconf="${myconf} --disable-gssapi"

	# Kerberos 4 support doesn't compile.. and i'm not sure why
	# If you want to test/fix for me, emerge kth-krb
	# and have at it. :) -raker 02/07/2003
	#
	#if [ "`use krb4`" ]; then
	#	myconf="${myconf} --enable-krb4=/usr/athena"
	#else
		myconf="${myconf} --disable-krb4"
	#fi

	use java && myconf="${myconf} --enable-java --with-javabase=${JAVA_HOME}"

	use pam || myconf="${myconf} --without-pam"

	# opie is not in portage yet so no otp support
	myconf="${myconf} --disable-otp"
	# use otp && myconf="${myconf} --with-opie=/usr"

	econf \
		--with-saslauthd=/var/lib/sasl2 \
		--with-pwcheck=/var/lib/sasl2 \
		--with-configdir=/etc/sasl2 \
		--with-plugindir=/usr/lib/sasl2 \
		--with-dbpath=/etc/sasl2/sasldb2 \
		${myconf}

	emake || die "compile problem"
}

src_install () {

	einstall || die "install problem"

	dodoc AUTHORS ChangeLog COPYING NEWS README doc/*.txt
	docinto examples ; dodoc sample/{*.[ch],Makefile}
	newdoc pwcheck/README README.pwcheck
	dohtml doc/*

	dodir /var/lib/sasl2
	dodir /etc/sasl2
	# generate an empty sasldb2 with correct permissions
	LD_OLD=${LD_LIBRARY_PATH}
	export LD_LIBRARY_PATH=${S}/lib/.libs
	echo "gentoo" | ${D}usr/sbin/saslpasswd2 -f ${D}etc/sasl2/sasldb2 -p cyrus
	${D}usr/sbin/saslpasswd2 -f ${D}etc/sasl2/sasldb2 -d cyrus
	export LD_LIBRARY_PATH=${LD_OLD}
	chown root.mail ${D}etc/sasl2/sasldb2
	chmod 0640 ${D}etc/sasl2/sasldb2

	insinto /etc/conf.d ; newins ${FILESDIR}/saslauthd.confd-2.1 saslauthd
	exeinto /etc/init.d ; newexe ${FILESDIR}/saslauthd2.rc6 saslauthd
	exeinto /etc/init.d ; newexe ${FILESDIR}/pwcheck.rc6 pwcheck
}
