# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/net-snmp/net-snmp-5.0.1.ebuild,v 1.3 2002/08/14 12:12:26 murphy Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Software for generating and retrieving SNMP data"
SRC_URI="mirror://sourceforge/net-snmp/${P}.tar.gz"
HOMEPAGE="http://net-snmp.sourceforge.net/"

DEPEND="virtual/glibc <sys-libs/db-2
	>=sys-libs/zlib-1.1.4
	ssl? ( >=dev-libs/openssl-0.9.6 )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	ssl? ( >=dev-libs/openssl-0.9.6d )
	kerberos? ( >=app-crypt/krb5-1.2.5 )"
	
SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc sparc64"

src_compile() {
	local myconf disable_sec_services

	use ssl || myconf="${myconf} --enable-internal-md5 --with-openssl=no"
	use tcpd && myconf="${myconf} --with-libwrap" || myconf="${myconf} --with-libwrap=no"
	use ipv6 && myconf="${myconf} --enable-ipv6" || myconf="${myconf} --disable-ipv6"
	use ipv6 || myconf="${myconf} --with-out-transports=\"TCPIPv6 UDPIPv6\""
	use kerberos && myconf="${myconf} --with-security-modules=\"usm ksm\""

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
		--host=${CHOST} ${myconf} || die "bad ./configure"

	emake || die "compile problem"
}

src_install () {

	einstall exec_prefix=${D}/usr \
		persistentdir=${D}/var/lib/net-snmp || die

	dodir /var/lib/net-snmp

	dodoc AGENT.txt ChangeLog FAQ INSTALL NEWS PORTING README* TODO EXAMPLE.conf.def

	exeinto /etc/init.d
	newexe ${FILESDIR}/net-snmpd.rc6 net-snmpd
}
