# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/squid/squid-2.5.5-r2.ebuild,v 1.6 2004/06/16 19:59:01 dostrow Exp $

IUSE="pam ldap ssl sasl snmp debug"

#lame archive versioning scheme..
S_PV=${PV%.*}
S_PL=${PV##*.}
S_PP=${PN}-${S_PV}.STABLE${S_PL}

DESCRIPTION="A caching web proxy, with advanced features"
HOMEPAGE="http://www.squid-cache.org/"

S=${WORKDIR}/${S_PP}
SRC_URI="ftp://ftp.squid-cache.org/pub/squid-2/STABLE/${S_PP}.tar.bz2"

RDEPEND="virtual/glibc
	pam? ( >=sys-libs/pam-0.72 )
	ldap? ( >=net-nds/openldap-2.0.25 )
	ssl? ( >=dev-libs/openssl-0.9.6g )
	sasl? ( >=dev-libs/cyrus-sasl-1.5.27 )
	selinux? ( sec-policy/selinux-squid )"
DEPEND="${RDEPEND} dev-lang/perl"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha hppa ~ia64 s390"
SLOT="0"

src_unpack() {
	unpack ${A} || die
	cd ${S} || die

	#do NOT just remove this patch.  yes, it's here for a reason.
	#woodchip@gentoo.org (07 Nov 2002)
	patch -p1 <${FILESDIR}/squid-2.5.3-gentoo.diff || die

	# Fix vunerability in ntml as listed on bug #53367
	epatch ${FILESDIR}/squid-${PV}-ntml-auth-fix.patch || die

	#hmm #10865
	cd helpers/external_acl/ldap_group
	cp Makefile.in Makefile.in.orig
	sed -e 's%^\(LINK =.*\)\(-o.*\)%\1\$(XTRA_LIBS) \2%' \
		Makefile.in.orig > Makefile.in

	if [ -z "`use debug`" ]
	then
		cd ${S}
		mv configure.in configure.in.orig
		sed -e 's%LDFLAGS="-g"%LDFLAGS=""%' configure.in.orig > configure.in
		export WANT_AUTOCONF=2.1
		autoconf || die
	fi
}

src_compile() {
	local basic_modules="getpwnam,YP,NCSA,SMB,MSNT,multi-domain-NTLM,winbind"
	use ldap && basic_modules="LDAP,${basic_modules}"
	use pam && basic_modules="PAM,${basic_modules}"
	if [ `use sasl` ]; then
		basic_modules="SASL,${basic_modules}"
		#support for cyrus-sasl-1.x and 2.x; thanks Raker!
		if [ -f /usr/include/sasl/sasl.h ]; then
			cd ${S}/helpers/basic_auth/SASL/
			cp sasl_auth.c sasl_auth.c.orig
			sed \
				-e "s:sasl.h:sasl/sasl.h:" \
				-e "s:NULL, NULL, NULL:NULL, NULL, NULL, NULL, NULL:" \
				-e "s:strlen(password), \&errstr:strlen(password):" \
				< sasl_auth.c.orig > sasl_auth.c
			cp Makefile.in Makefile.in.orig
			sed -e "s:-lsasl:-lsasl2:" \
				< Makefile.in.orig > Makefile.in
			cd ${S}
		fi
	fi

	local ext_helpers="ip_user,unix_group,wbinfo_group,winbind_group"
	use ldap && ext_helpers="ldap_group,${ext_helpers}"

	local myconf=""
	use snmp && myconf="${myconf} --enable-snmp" || myconf="${myconf} --disable-snmp"
	use ssl && myconf="${myconf} --enable-ssl" || myconf="${myconf} --disable-ssl"

	if [ `use underscores` ]; then
		ewarn "Enabling underscores in domain names will result in dns resolution"
		ewarn "failure if your local DNS client (probably bind) is not compatible."
		myconf="${myconf} --enable-underscores"
	fi

	./configure \
		--prefix=/usr \
		--bindir=/usr/bin \
		--exec-prefix=/usr \
		--sbindir=/usr/sbin \
		--localstatedir=/var \
		--mandir=/usr/share/man \
		--sysconfdir=/etc/squid \
		--libexecdir=/usr/lib/squid \
		\
		--enable-auth="basic,digest,ntlm" \
		--enable-removal-policies="lru,heap" \
		--enable-digest-auth-helpers="password" \
		--enable-storeio="ufs,diskd,coss,aufs,null" \
		--enable-basic-auth-helpers=${basic_modules} \
		--enable-external-acl-helpers=${ext_helpers} \
		--enable-ntlm-auth-helpers="SMB,fakeauth,no_check,winbind" \
		--enable-linux-netfilter \
		--enable-ident-lookups \
		--enable-useragent-log \
		--enable-cache-digests \
		--enable-delay-pools \
		--enable-referer-log \
		--enable-async-io \
		--enable-truncate \
		--enable-arp-acl \
		--with-pthreads \
		--enable-htcp \
		--enable-carp \
		--enable-poll \
		--host=${CHOST} ${myconf} || die "bad ./configure"
		#--enable-icmp

	mv include/autoconf.h include/autoconf.h.orig
	sed -e "s:^#define SQUID_MAXFD.*:#define SQUID_MAXFD 4096:" \
		include/autoconf.h.orig > include/autoconf.h

#	if [ "${ARCH}" = "hppa" ]
#	then
#		mv include/autoconf.h include/autoconf.h.orig
#		sed -e "s:^#define HAVE_MALLOPT 1:#undef HAVE_MALLOPT:" \
#			include/autoconf.h.orig > include/autoconf.h
#	fi

	emake || die "compile problem"
}

src_install() {
	make DESTDIR=${D} install || die

	#--enable-icmp
	#make -C src install-pinger libexecdir=${D}/usr/lib/squid || die
	#chown root:squid ${D}/usr/lib/squid/pinger
	#chmod 4750 ${D}/usr/lib/squid/pinger

	#need suid root for looking into /etc/shadow
	chown root:squid ${D}/usr/lib/squid/ncsa_auth
	chown root:squid ${D}/usr/lib/squid/pam_auth
	chmod 4750 ${D}/usr/lib/squid/ncsa_auth
	chmod 4750 ${D}/usr/lib/squid/pam_auth

	#some clean ups
	rm -rf ${D}/var
	mv ${D}/usr/bin/Run* ${D}/usr/lib/squid

	#simply switch this symlink to choose the desired language..
	dosym /usr/lib/squid/errors/English /etc/squid/errors

	dodoc CONTRIBUTORS COPYING COPYRIGHT CREDITS \
		ChangeLog QUICKSTART SPONSORS doc/*.txt \
		helpers/ntlm_auth/no_check/README.no_check_ntlm_auth
	newdoc helpers/basic_auth/SMB/README README.auth_smb
	dohtml helpers/basic_auth/MSNT/README.html RELEASENOTES.html
	newdoc helpers/basic_auth/LDAP/README README.auth_ldap
	doman helpers/basic_auth/LDAP/*.8
	dodoc helpers/basic_auth/SASL/squid_sasl_auth*

	insinto /etc/pam.d ; newins ${FILESDIR}/squid.pam squid
	exeinto /etc/init.d ; newexe ${FILESDIR}/squid.rc6 squid
	insinto /etc/conf.d ; newins ${FILESDIR}/squid.confd squid
	exeinto /etc/cron.weekly ; newexe ${FILESDIR}/squid-r1.cron squid.cron
}

pkg_postinst() {
	# empty dirs..
	install -m0755 -o squid -g squid -d ${ROOT}/var/cache/squid
	install -m0755 -o squid -g squid -d ${ROOT}/var/log/squid
}
