# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/lprng/lprng-3.8.28.ebuild,v 1.10 2006/11/06 23:45:43 genstef Exp $

inherit eutils flag-o-matic

IUSE="foomaticdb kerberos nls ssl"

MY_PN=LPRng

S=${WORKDIR}/${MY_PN}-${PV}
DESCRIPTION="Extended implementation of the Berkeley LPR print spooler"
HOMEPAGE="http://www.lprng.com/"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc ~ppc64 sparc x86"
SRC_URI="ftp://ftp.lprng.com/pub/${MY_PN}/${MY_PN}/${MY_PN}-${PV}.tgz"

PROVIDE="virtual/lpr"

RDEPEND="virtual/libc
	sys-process/procps
	ssl? ( dev-libs/openssl )
	foomaticdb? ( net-print/foomatic )
	!virtual/lpr"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	kerberos? ( app-crypt/mit-krb5 )"

LICENSE="|| ( GPL-2 Artistic )"
SLOT="0"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-3.8.27-certs.diff
	epatch ${FILESDIR}/${P}-lpq.diff
	epatch ${FILESDIR}/${P}-make.diff
	epatch ${FILESDIR}/${P}-krb.diff
}

src_compile() {
	# wont compile with -O3, needs -O2
	replace-flags -O[3-9] -O2

	econf \
		$(use_enable nls) \
		$(use_enable kerberos) \
		$(use_enable ssl) \
		--disable-setuid \
		--with-userid=lp \
		--with-groupid=lp \
		--with-lpd_conf_path=/etc/lprng/lpd.conf \
		--with-lpd_perms_path=/etc/lprng/lpd.perms \
		--libexecdir=/usr/libexec/lprng \
		--sysconfdir=/etc/lprng \
		--disable-strip || die "econf failed"

	emake -j1 || die "printer on fire!"
}

src_install() {
	dodir /var/spool/lpd
	diropts -m 700 -o lp -g lp
	dodir /var/spool/lpd/lp

	emake install \
		DESTDIR=${D} \
		POSTINSTALL="NO" \
		gnulocaledir=${D}/usr/share/locale || die "emake install failed"

	dodoc CHANGES COPYRIGHT LICENSE README VERSION \
		${FILESDIR}/printcap lpd.conf lpd.perms
	dohtml HOWTO/*

	insinto /etc/lprng
	doins ${FILESDIR}/printcap lpd.conf lpd.perms
	dosym /etc/lprng/printcap /etc/printcap
	exeinto /etc/init.d
	newexe ${FILESDIR}/lprng-init lprng
}

pkg_postinst() {
	einfo "If printing does not work, try 'checkpc'/'checkpc -f'"
}
