# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/heimdal/heimdal-0.6.3-r1.ebuild,v 1.4 2005/01/01 12:31:44 eradicator Exp $

inherit libtool eutils

DESCRIPTION="Kerberos 5 implementation from KTH"
HOMEPAGE="http://www.pdc.kth.se/heimdal/"
SRC_URI="ftp://ftp.pdc.kth.se/pub/heimdal/src/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips sparc ppc x86"
IUSE="ssl berkdb ipv6 krb4 ldap"

RDEPEND="ssl? ( dev-libs/openssl )
	berkdb? ( sys-libs/db )
	krb4? ( >=app-crypt/kth-krb-1.2.2-r2 )
	ldap? ( net-nds/openldap )
	!virtual/krb5"
	# With this enabled, we create a multiple stage
	# circular dependency with USE="ldap kerberos"
	# -- Kain <kain@kain.org> 05 Dec 2002
DEPEND="${RDEPEND}
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/gcc
	>=sys-apps/sed-4"
PROVIDE="virtual/krb5"

src_unpack() {
	unpack ${A} ; cd ${S}

	epatch ${FILESDIR}/${P}-ldap-subtree.patch.bz2
	epatch ${FILESDIR}/${P}-no_libedit.patch.bz2
	epatch ${FILESDIR}/${P}-fPIC.patch.bz2
	epatch ${FILESDIR}/${P}-rxapps.patch.bz2
	epatch ${FILESDIR}/${P}-berkdb.patch.bz2
	epatch ${FILESDIR}/${P}-suid_fix.patch.bz2
}

src_compile() {
	elibtoolize

	aclocal -I cf || die "configure problem"
	autoheader || die "configure problem"
	automake -a || die "configure problem"
	autoconf || die "configure problem"

	local myconf="
		$(use_with ipv6)
		$(use_with berkdb berkeley-db)
		$(use_with ssl openssl)
		--enable-shared
		--includedir=/usr/include/heimdal
		--libexecdir=/usr/sbin"

	use krb4 \
		&& myconf="${myconf} --with-krb4 --with-krb4-config=/usr/athena/bin/krb4-config" \
		|| myconf="${myconf} --without-krb4"

	use ldap && myconf="${myconf} --with-openldap=/usr"

	econf ${myconf} || die "econf failed"
	emake		|| die
}

src_install() {
	make DESTDIR=${D} \
		install || die

	dodoc ChangeLog README NEWS TODO

	# Begin client rename and install
	for i in {telnetd,ftpd}
	do
		mv ${D}/usr/share/man/man8/${i}.8 ${D}/usr/share/man/man8/k${i}.8
		mv ${D}/usr/sbin/${i} ${D}/usr/sbin/k${i}
	done
	for i in {rcp,rsh,telnet,ftp}
	do
		mv ${D}/usr/share/man/man1/${i}.1 ${D}/usr/share/man/man1/k${i}.1
		mv ${D}/usr/bin/${i} ${D}/usr/bin/k${i}
	done

	# Create symlinks for the includes
	cd ${D}/usr/include/ && \
		ln -s heimdal gssapi && \
		ln -s heimdal/krb5-types.h krb5-types.h && \
		ln -s heimdal/krb5.h krb5.h && \
		ln -s heimdal/asn1_err.h asn1_err.h && \
		ln -s heimdal/krb5_asn1.h krb5_asn1.h && \
		ln -s heimdal/krb5_err.h krb5_err.h && \
		ln -s heimdal/heim_err.h heim_err.h && \
		ln -s heimdal/k524_err.h k524_err.h && \
		ln -s heimdal/krb5-protos.h krb5-protos.h \
	|| die "Creation of include symlinks failed."

	dodir /etc/init.d
	exeinto /etc/init.d

	doexe ${FILESDIR}/heimdal-kdc \
		${FILESDIR}/heimdal-kadmind \
		${FILESDIR}/heimdal-kpasswdd

	insinto /etc
		newins ${FILESDIR}/krb5.conf krb5.conf

	if use ldap;
	then
		insinto /etc/openldap/schema
		newins ${FILESDIR}/krb5-kdc.schema krb5-kdc.schema
	fi


	# default database dir
	dodir /var/heimdal
}
