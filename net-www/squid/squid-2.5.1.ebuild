# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/squid/squid-2.5.1.ebuild,v 1.6 2003/07/13 21:44:10 aliz Exp $

IUSE="pam ldap ssl sasl snmp"

#lame archive versioning scheme..
S_PV=${PV%.*}
S_PL=${PV##*.}
S_PP=${PN}-${S_PV}.STABLE${S_PL}

DESCRIPTION="A caching web proxy, with advanced features"
HOMEPAGE="http://www.squid-cache.org/"

S=${WORKDIR}/${S_PP}
SRC_URI="ftp://ftp.squid-cache.org/pub/squid-2/STABLE/${S_PP}.tar.bz2"

RDEPEND="pam? >=sys-libs/pam-0.72
	ldap? >=net-nds/openldap-2
	ssl? >=dev-libs/openssl-0.9.6g
	sasl? =dev-libs/cyrus-sasl-1*"
DEPEND="${RDEPEND} dev-lang/perl"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha"
SLOT="0"

src_unpack() {
	unpack ${A} || die
	cd ${S} || die

	#do NOT just remove this patch.  yes, it's here for a reason.
	#woodchip@gentoo.org (07 Nov 2002)
	patch -p1 <${FILESDIR}/${P}-gentoo.diff || die

	if [ -z "$DEBUGBUILD" ]
	then
		mv configure.in configure.in.orig
		sed -e 's%LDFLAGS="-g"%LDFLAGS=""%' configure.in.orig > configure.in
		autoconf || die
	fi
}

src_compile() {
	local basic_modules="getpwnam,YP,NCSA,SMB,MSNT,multi-domain-NTLM,winbind"
	use ldap && basic_modules="LDAP,${basic_modules}"
	use pam && basic_modules="PAM,${basic_modules}"
	use sasl && basic_modules="SASL,${basic_modules}"

	local ext_helpers="ip_user,unix_group,wbinfo_group,winbind_group"
	use ldap && ext_helpers="ldap_group,${ext_helpers}"

	local myconf=""
	use snmp && myconf="${myconf} --enable-snmp" || myconf="${myconf} --disable-snmp"
	use ssl && myconf="${myconf} --enable-ssl" || myconf="${myconf} --disable-ssl"

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
		--disable-ident-lookups \
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

	emake || die "compile problem"
}

src_install() {
	make DESTDIR=${D} install || die

	#--enable-icmp
	#make -C src install-pinger libexecdir=${D}/usr/lib/squid || die
	#chown root.squid ${D}/usr/lib/squid/pinger
	#chmod 4750 ${D}/usr/lib/squid/pinger

	#some clean ups
	rm -rf ${D}/var
	mv ${D}/usr/bin/Run* ${D}/usr/lib/squid

	#simply switch this symlink to choose the desired language..
	dosym /usr/lib/squid/errors/English /etc/squid/errors

	dodoc README QUICKSTART CONTRIBUTORS COPYRIGHT COPYING \
		CREDITS ChangeLog doc/*.txt \
		helpers/ntlm_auth/no_check/README.no_check_ntlm_auth
	newdoc helpers/basic_auth/SMB/README README.auth_smb
	dohtml helpers/basic_auth/MSNT/README.html
	newdoc helpers/basic_auth/LDAP/README README.auth_ldap
	doman helpers/basic_auth/LDAP/*.8
	dodoc helpers/basic_auth/SASL/squid_sasl_auth*

	insinto /etc/pam.d ; newins ${FILESDIR}/squid.pam squid
	exeinto /etc/init.d ; newexe ${FILESDIR}/squid.rc6 squid
	insinto /etc/conf.d ; newins ${FILESDIR}/squid.confd squid
}

pkg_postinst() {
	# empty dirs..
	install -m0755 -o squid -g squid -d ${ROOT}/var/cache/squid
	install -m0755 -o squid -g squid -d ${ROOT}/var/log/squid
}
