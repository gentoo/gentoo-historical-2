# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-mail/cyrus-imapd/cyrus-imapd-2.1.11.ebuild,v 1.5 2003/02/13 14:27:34 vapier Exp $

DESCRIPTION="The Cyrus IMAP Server"
HOMEPAGE="http://asg.web.cmu.edu/cyrus/imapd/"
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 -ppc -sparc "

PROVIDE="virtual/imapd"
DEPEND="virtual/glibc
	afs? ( >=net-fs/openafs-1.2.2 )
	snmp? ( >=net-analyzer/ucd-snmp-4.2.3 )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	kerberos? ( >=app-crypt/kth-krb-1.2 )
	>=sys-libs/db-3.2
	>=sys-libs/pam-0.75
	>=dev-libs/cyrus-sasl-2.1.2
	>=sys-apps/tcp-wrappers-7.6
	net-mail/mailbase"

pkg_setup() {
	if ! grep -q ^cyrus: /etc/passwd ; then
		useradd -c cyrus -d /usr/cyrus -g mail -s /bin/false -u 96 cyrus \
			|| die "problem adding user cyrus"
	fi
}

src_unpack() {

	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/configure.diff || die "patch failed"

}

src_compile() {
	local myconf
	
	use afs && myconf="--with-afs" \
		|| myconf="--without-afs"

	use snmp && myconf="${myconf} --with-ucdsnmp=/usr" \
		|| myconf="${myconf} --without-ucdsnmp"

	use ssl && myconf="${myconf} --with-openssl=/usr" \
		|| myconf="${myconf} --without-openssl"

	use kerberos && myconf="${myconf} --with-krb=/usr/athena --with-auth=krb --enable-gssapi" \
		|| myconf="${myconf} --without-krb --with-auth=unix --disable-gssapi"

	econf \
		--enable-listext \
		--with-cyrus-group=mail \
		--enable-netscapehack \
		--with-com_err=yes \
		--without-perl \
		--disable-cyradm \
		--with-libwrap=/usr \
		${myconf}

	# make depends break with -f... in CFLAGS
	make depend CFLAGS="" || die "make depend problem"

	make || die "compile problem"
}

src_install() {
	make DESTDIR=${D} install || die

	# Remove the developer stuff (-> dev-libs/cyrus-imap-devel)
	rm -rf ${D}usr/include ${D}usr/lib

	# Rename the master from cyrus to cyrusmaster (postfix has a master too)
	mv ${D}usr/cyrus/bin/master ${D}usr/cyrus/bin/cyrusmaster

	# Fix manpage stuff
	rm -rf ${D}usr/man

	# master is renamed to cyrusmaster because postfix has a master too
	mv man/master.8 man/cyrusmaster.8
	patch man/cyrusmaster.8 ${FILESDIR}/master.8.diff || die "error patching master.8"

	doman man/*.?

	# remove man-pages from packet net-mail/cyrus-imapd-admin
	rm ${D}usr/share/man/man1/installsieve.1.gz ${D}usr/share/man/man1/sieveshell.1.gz

	dodir /etc 
	cp ${FILESDIR}/imapd_2.conf ${D}etc/imapd.conf
	cp ${FILESDIR}/cyrus_2.conf ${D}etc/cyrus.conf
	dodir /etc/pam.d
	cp ${FILESDIR}/pam.d-imap ${D}etc/pam.d/imap

	dodir /var
	mkdir -m 0750 ${D}var/imap
	chown -R cyrus.mail ${D}var/imap 
	mkdir -m 0755 ${D}var/imap/db
	chown -R cyrus.mail ${D}var/imap/db
	mkdir -m 0755 ${D}var/imap/log
	chown -R cyrus.mail ${D}var/imap/log
	mkdir -m 0755 ${D}var/imap/msg
	chown -R cyrus.mail ${D}var/imap/msg
	mkdir -m 0755 ${D}var/imap/user
	chown -R cyrus.mail ${D}var/imap/user
	for i in a b c d e f g h i j k l m n o p q r s t u v w x y z ; do mkdir -m 0755 ${D}var/imap/user/$i ; \
		chown -R cyrus.mail ${D}var/imap/user/$i
	done
	mkdir -m 0755 ${D}var/imap/proc
	chown -R cyrus.mail ${D}var/imap/proc
	mkdir -m 0755 ${D}var/imap/quota
	for i in a b c d e f g h i j k l m n o p q r s t u v w x y z ; do mkdir -m 0755 ${D}var/imap/quota/$i ; \
		chown -R cyrus.mail ${D}var/imap/quota/$i
	done
	mkdir -m 0755 ${D}var/imap/sieve
        chown -R cyrus.mail ${D}var/imap/sieve
	for i in a b c d e f g h i j k l m n o p q r s t u v w x y z ; do mkdir -m 0755 ${D}var/imap/sieve/$i ; \
	    chown -R cyrus.mail ${D}var/imap/sieve/$i ; done
   	mkdir -m 0755 ${D}var/imap/socket
        chown -R cyrus.mail ${D}var/imap/socket

	mkdir ${D}var/spool
	mkdir -m 0750 ${D}var/spool/imap
        chown -R cyrus.mail ${D}var/spool/imap
	mkdir -m 0755 ${D}var/spool/imap/stage.
        chown -R cyrus.mail ${D}var/spool/imap/stage.
	# For hashimapspool
	for i in a b c d e f g h i j k l m n o p q r s t u v w x y z ; do mkdir -m 0755 ${D}var/spool/imap/$i ; \
	    chown -R cyrus.mail ${D}var/spool/imap/$i ; done


	dodoc COPYRIGHT README*
	dohtml doc/*.html doc/murder.png
	cp doc/cyrusv2.mc ${D}usr/share/doc/${PF}/html
	cp -r contrib tools ${D}usr/share/doc/${PF}

	# Remove the CVS directories
	find 2>/dev/null ${D}usr/share/doc/ -type d -name CVS -exec rm -rf '{}' \;

	exeinto /etc/init.d ; newexe ${FILESDIR}/cyrus.rc6_2 cyrus

	if [ "'use ssl'" ]; then
		# from mod_ssl
		echo "Generating self-signed test certificate"
		echo "(Ignore any message from the yes command below)"
		mkdir certs
		cd certs
		yes "" | ${FILESDIR}/gentestcrt.sh >/dev/null 2>&1
		mkdir ${D}etc/cyrusimapd
		cp server.crt server.key ${D}etc/cyrusimapd
		chown cyrus.root ${D}etc/cyrusimapd/server.crt ${D}etc/cyrusimapd/server.key
		chmod 0400 ${D}etc/cyrusimapd/server.crt ${D}etc/cyrusimapd/server.key
	fi
}

pkg_postinst() {
	ewarn "If you change the fs-type of /var/imap or"
	ewarn "/var/spool/imap you should read step 9 of"
	ewarn "/usr/share/doc/${P}/html/install-configure.html."
	echo ""

	if df -T /var/imap | grep -q ' ext[23] ' ; then
		ewarn "Setting /var/imap/user/* and /var/imap/quota/* to synchronous"
		ewarn "updates."
		chattr +S /var/imap/user /var/imap/user/* /var/imap/quota /var/imap/quota/*
		echo ""
	fi

	if df -T /var/spool/imap | grep -q ' ext[23] ' ; then
		ewarn "Setting /var/spool/imap/* to synchronous updates."
		chattr +S /var/spool/imap /var/spool/imap/*
		echo ""
	fi

	ewarn "If the queue directory of the mail daemon resides on an ext2"
	ewarn "or ext3 partition you need to set it manually to update"
	ewarn "synchronously. E.g. 'chattr +S /var/spool/mqueue'."
	echo ""

	einfo "For correct logging with syslog add"
	einfo "\tlocal6.* /var/log/imapd.log"
	einfo "\tauth.debug /var/log/auth.log"
	einfo "to /etc/syslog.conf."
	echo ""

	ewarn "You have to add user cyrus to the sasldb2. Do this with:"
	ewarn "\tsaslpasswd2 cyrus"
}
