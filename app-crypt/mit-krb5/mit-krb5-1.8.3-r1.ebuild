# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/mit-krb5/mit-krb5-1.8.3-r1.ebuild,v 1.5 2010/11/26 08:37:09 hwoarang Exp $

EAPI="2"

inherit eutils flag-o-matic versionator

MY_P=${P/mit-}
P_DIR=$(get_version_component_range 1-2)
DESCRIPTION="MIT Kerberos V"
HOMEPAGE="http://web.mit.edu/kerberos/www/"
SRC_URI="http://web.mit.edu/kerberos/dist/krb5/${P_DIR}/${MY_P}-signed.tar"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE="ldap doc xinetd"

RDEPEND="!!app-crypt/heimdal
	>=sys-libs/e2fsprogs-libs-1.41.0
	sys-apps/keyutils
	ldap? ( net-nds/openldap )
	xinetd? ( sys-apps/xinetd )"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

S=${WORKDIR}/${MY_P}/src

PROVIDE="virtual/krb5"

src_unpack() {
	unpack ${A}
	unpack ./"${MY_P}".tar.gz
}

src_prepare() {
	epatch "${FILESDIR}/CVE-2010-1322.patch"
}

src_configure() {
	append-flags "-I/usr/include/et"
	econf \
		$(use_with ldap) \
		--without-krb4 \
		--enable-shared \
		--with-system-et \
		--with-system-ss \
		--enable-dns-for-realm \
		--enable-kdc-replay-cache \
		--disable-rpath
}

src_compile() {
	emake -j1 || die "emake failed"

	if use doc ; then
		cd ../doc
		for dir in api implement ; do
			emake -C "${dir}" || die "doc emake failed"
		done
	fi
}

src_test() {
	einfo "Tests do not run in sandbox, they need mit-krb5 to be already installed to test it."
}

src_install() {
	emake \
		DESTDIR="${D}" \
		EXAMPLEDIR="/usr/share/doc/${PF}/examples" \
		install || die "install failed"

	# default database dir
	keepdir /var/lib/krb5kdc

	cd ..
	dodoc README
	dodoc doc/*.ps
	doinfo doc/*.info*
	dohtml -r doc/*

	# die if we cannot respect a USE flag
	if use doc ; then
	    dodoc doc/{api,implement}/*.ps || die "dodoc failed"
	fi

	newinitd "${FILESDIR}"/mit-krb5kadmind.initd mit-krb5kadmind
	newinitd "${FILESDIR}"/mit-krb5kdc.initd mit-krb5kdc

	insinto /etc
	newins "${D}/usr/share/doc/${PF}/examples/krb5.conf" krb5.conf.example
	insinto /var/lib/krb5kdc
	newins "${D}/usr/share/doc/${PF}/examples/kdc.conf" kdc.conf.example

	if use ldap ; then
		insinto /etc/openldap/schema
		doins "${S}/plugins/kdb/ldap/libkdb_ldap/kerberos.schema"
	fi

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/kpropd.xinetd" kpropd
	fi
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-1.8.0" ; then
		einfo ""
		elog "MIT split the Kerberos applications from the base Kerberos"
		elog "distribution.  Kerberized versions of telnet, rlogin, rsh, rcp,"
		elog "ftp clients and telnet, ftp deamons now live in"
		elog "\"app-crypt/mit-krb5-appl\" package."
		einfo ""
	fi
}
