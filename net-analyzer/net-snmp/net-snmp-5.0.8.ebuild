# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/net-snmp/net-snmp-5.0.8.ebuild,v 1.5 2003/06/14 01:54:06 gmsoft Exp $

IUSE="ssl kerberos ipv6 tcpd"

PROVIDES="virtual/snmp"
S=${WORKDIR}/${P%[a-z]}
DESCRIPTION="Software for generating and retrieving SNMP data"
SRC_URI="mirror://sourceforge/net-snmp/${P}.tar.gz"
HOMEPAGE="http://net-snmp.sourceforge.net/"

DEPEND="virtual/glibc <sys-libs/db-2
	>=sys-libs/zlib-1.1.4
	>=sys-apps/sed-4
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	ssl? ( >=dev-libs/openssl-0.9.6d )
	kerberos? ( >=app-crypt/mit-krb5-1.2.5 )"
	
SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86 ~ppc ~sparc ~arm ~hppa"

src_unpack() {
	unpack ${A}

	cd ${S}

	# 5.0.8 compiles without this patch, and the filename doesn't
	# match anyway, so disabling for now
	# Robert Coie <rac@gentoo.org> 2003.06.05
	#patch -p1 < ${FILESDIR}/${P}-gentoo.diff

# Kerberos support trips with a compile error
#	use kerberos && {
#		cp "${S}/configure" "${S}/configure.tmp"
#		sed 's:security_def_list="usm":security_def_list="usm ksm":' \
#			"${S}/configure.tmp" > "${S}/configure"
#	}
}

src_compile() {
	local myconf disable_sec_services

	use ssl || myconf="${myconf} --enable-internal-md5 --with-openssl=no"
	use tcpd && myconf="${myconf} --with-libwrap" || myconf="${myconf} --with-libwrap=no"
	use ipv6 && myconf="${myconf} --enable-ipv6" || myconf="${myconf} --disable-ipv6"

#	Doesn't seem that emerge passes the escaped double quotes properly 
#	use kerberos && myconf="--with-security-modules=usm ksm"

econf \
		--with-cflags="${CFLAGS}" \
		--host="${CHOST}" \
		--with-zlib \
		--enable-shared \
		--with-sys-location="Unknown" \
		--with-sys-contact="root@Unknown" \
		--with-default-snmp-version="3" \
		--with-logfile=/var/log/net-snmpd.log \
		--with-persistent-directory=/var/lib/net-snmp \
		--with-mib-modules=host \
		${myconf} || die "bad ./configure"

	# Parallel make doesn't work.
	make || die "compile problem"
}

src_install () {

	einstall exec_prefix=${D}/usr \
		persistentdir=${D}/var/lib/net-snmp || die

	dodir /var/lib/net-snmp

	dodoc AGENT.txt ChangeLog FAQ INSTALL NEWS PORTING README* TODO EXAMPLE.conf.def

	# Close bug #5882:
	rm -f ${D}/usr/bin/snmptrap
	dosym /usr/bin/snmptrap /usr/bin/snmpinform

	cp ${FILESDIR}/net-snmpd.rc6 net-snmpd
	sed -i "s:doc\/net-snmp:doc\/${PF}:" net-snmpd
	
	exeinto /etc/init.d
	newexe net-snmpd net-snmpd
}
