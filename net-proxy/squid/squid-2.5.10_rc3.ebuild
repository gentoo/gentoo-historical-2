# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/squid/squid-2.5.10_rc3.ebuild,v 1.10 2005/07/16 10:14:17 mrness Exp $

inherit eutils toolchain-funcs

#lame archive versioning scheme..
S_PV=${PV%.*}
S_PL=${PV##*.}
S_PL=${S_PL/_rc/-RC}
S_PP=${PN}-${S_PV}.STABLE${S_PL}
PATCH_VERSION="20050510"

DESCRIPTION="A caching web proxy, with advanced features"
HOMEPAGE="http://www.squid-cache.org/"
SRC_URI="http://www.squid-cache.org/Versions/v2/${S_PV}/${S_PP}.tar.gz
	mirror://gentoo/${S_PP}-patches-${PATCH_VERSION}.tar.gz"

S=${WORKDIR}/${S_PP}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 mips"
IUSE="pam ldap ssl sasl snmp debug selinux underscores logrotate customlog zero-penalty-hit"

RDEPEND="virtual/libc
	pam? ( >=sys-libs/pam-0.75 )
	ldap? ( >=net-nds/openldap-2.1.26 )
	ssl? ( >=dev-libs/openssl-0.9.6m )
	sasl? ( >=dev-libs/cyrus-sasl-1.5.27 )
	selinux? ( sec-policy/selinux-squid )
	!mips? ( logrotate? ( app-admin/logrotate ) )"
DEPEND="${RDEPEND} dev-lang/perl"

src_unpack() {
	unpack ${A} || die "unpack failed"
	cd ${S} || die "dir ${S} not found"

	# Do bulk patching from squids bug fix list as well as our patches
	use customlog || rm ${WORKDIR}/patch/9*customlog*
	use zero-penalty-hit || rm ${WORKDIR}/patch/9*ToS_Hit*
	EPATCH_SUFFIX="patch"
	epatch ${WORKDIR}/patch

	#hmm #10865
	sed -i -e 's%^\(LINK =.*\)\(-o.*\)%\1\$(XTRA_LIBS) \2%' \
		helpers/external_acl/ldap_group/Makefile.in

	#disable lazy bindings on (some at least) suided basic auth programs
	sed -i -e 's:_LDFLAGS[ ]*=:_LDFLAGS = -Wl,-z,now:' \
		helpers/basic_auth/*/Makefile.in

	if ! use debug ;	then
		mv configure.in configure.in.orig
		sed -e 's%LDFLAGS="-g"%LDFLAGS=""%' configure.in.orig > configure.in
		export WANT_AUTOCONF=2.1
		autoconf || die "autoconf failed"
	fi
}

src_compile() {
	# Support for uclibc #61175
	if use elibc_uclibc; then
		local basic_modules="getpwnam,NCSA,SMB,MSNT,multi-domain-NTLM,winbind"
	else
		local basic_modules="getpwnam,YP,NCSA,SMB,MSNT,multi-domain-NTLM,winbind"
	fi

	use ldap && basic_modules="LDAP,${basic_modules}"
	use pam && basic_modules="PAM,${basic_modules}"
	use sasl && basic_modules="SASL,${basic_modules}"
	# SASL 1 / 2 Supported Natively

	local ext_helpers="ip_user,unix_group,wbinfo_group,winbind_group"
	use ldap && ext_helpers="ldap_group,${ext_helpers}"

	local myconf=""
	use snmp && myconf="${myconf} --enable-snmp" || myconf="${myconf} --disable-snmp"
	use ssl && myconf="${myconf} --enable-ssl" || myconf="${myconf} --disable-ssl"

	use amd64 && myconf="${myconf} --disable-internal-dns "

	if use underscores; then
		ewarn "Enabling underscores in domain names will result in dns resolution"
		ewarn "failure if your local DNS client (probably bind) is not compatible."
		myconf="${myconf} --enable-underscores"
	fi

	# Support for uclibc #61175
	if use elibc_uclibc; then
		myconf="${myconf} --enable-storeio='ufs,diskd,aufs,null' "
		myconf="${myconf} --disable-async-io "
	else
		myconf="${myconf} --enable-storeio='ufs,diskd,coss,aufs,null' "
		myconf="${myconf} --enable-async-io "
	fi

	export CC=$(tc-getCC)

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
		--enable-basic-auth-helpers=${basic_modules} \
		--enable-external-acl-helpers=${ext_helpers} \
		--enable-ntlm-auth-helpers="SMB,fakeauth,no_check,winbind" \
		--enable-linux-netfilter \
		--enable-ident-lookups \
		--enable-useragent-log \
		--enable-cache-digests \
		--enable-delay-pools \
		--enable-referer-log \
		--enable-truncate \
		--enable-arp-acl \
		--with-pthreads \
		--with-large-files \
		--enable-htcp \
		--enable-carp \
		--enable-poll \
		--host=${CHOST} ${myconf} || die "bad ./configure"
		#--enable-icmp

	mv include/autoconf.h include/autoconf.h.orig
	sed -e "s:^#define SQUID_MAXFD.*:#define SQUID_MAXFD 8192:" \
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

	insinto /etc/pam.d
	newins ${FILESDIR}/squid.pam squid
	exeinto /etc/init.d
	newexe ${FILESDIR}/squid.initd squid
	insinto /etc/conf.d
	newins ${FILESDIR}/squid.confd squid
	if use logrotate; then
		insinto /etc/logrotate.d
		newins ${FILESDIR}/squid-logrotate squid
	else
		exeinto /etc/cron.weekly
		newexe ${FILESDIR}/squid.cron squid.cron
	fi

	diropts -m0755 -o squid -g squid
	dodir /var/cache/squid /var/log/squid
}

pkg_postinst() {
	echo
	ewarn "Squid authentication helpers have been installed suid root"
	ewarn "This allows shadow based authentication, see bug #52977 for more"
	echo
}
