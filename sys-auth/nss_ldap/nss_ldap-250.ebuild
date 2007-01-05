# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/nss_ldap/nss_ldap-250.ebuild,v 1.3 2007/01/05 09:12:30 flameeyes Exp $

inherit fixheadtails eutils multilib

IUSE="debug sasl"

DESCRIPTION="NSS LDAP Module"
HOMEPAGE="http://www.padl.com/OSS/nss_ldap.html"
SRC_URI="http://www.padl.com/download/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"

DEPEND=">=net-nds/openldap-2.1.30-r5
		sasl? ( dev-libs/cyrus-sasl )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/nsswitch.ldap.diff
	epatch ${FILESDIR}/${PN}-239-tls-security-bug.patch
	epatch ${FILESDIR}/${PN}-249-sasl-compile.patch
	# fix head/tail stuff
	ht_fix_file ${S}/Makefile.am ${S}/Makefile.in ${S}/depcomp
	# fix build borkage
	for i in Makefile.{in,am}; do
	  sed -i.orig \
	    -e '/^install-exec-local: nss_ldap.so/s,nss_ldap.so,,g' \
	    ${S}/$i
	done
}

src_compile() {
	local myconf=""
	use debug && myconf="${myconf} --enable-debugging"

	econf \
		--with-ldap-lib=openldap \
		--libdir=/$(get_libdir) \
		--enable-schema-mapping \
		--enable-paged-results \
		--enable-rfc2307bis \
		${myconf} || die "configure failed"

	emake || die "make failed"
}

src_install() {
	dodir /$(get_libdir)

	emake -j1 DESTDIR="${D}" install || die "make install failed"

	insinto /etc
	doins ldap.conf

	dodoc ldap.conf ANNOUNCE NEWS ChangeLog AUTHORS \
		COPYING CVSVersionInfo.txt README nsswitch.ldap certutil
	docinto docs; dodoc doc/*
}
