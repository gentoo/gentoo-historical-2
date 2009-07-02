# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/logrotate/logrotate-3.7.8.ebuild,v 1.9 2009/07/02 19:36:10 maekke Exp $

EAPI="2"

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="Rotates, compresses, and mails system logs"
HOMEPAGE="https://fedorahosted.org/logrotate/"
SRC_URI="https://fedorahosted.org/releases/l/o/logrotate/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="selinux"

RDEPEND="
	>=dev-libs/popt-1.5
	selinux? ( sys-libs/libselinux )"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	selinux? ( sec-policy/selinux-logrotate )"

src_prepare() {
	strip-flags

	epatch ${FILESDIR}/${PN}-3.7.7-datehack.patch
	epatch ${FILESDIR}/${PN}-3.7.7-ignore-hidden.patch
	epatch ${FILESDIR}/${PN}-3.7.7-weekly.patch
	epatch ${FILESDIR}/${PN}-3.7.7-fbsd.patch
}

src_configure() {
	return
}

src_compile() {
	local myconf
	myconf="CC=$(tc-getCC)"
	useq selinux && myconf="${myconf} WITH_SELINUX=yes"
	use elibc_FreeBSD && append-flags -DNO_ALLOCA_H
	emake ${myconf} RPM_OPT_FLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	insinto /usr
	dosbin logrotate
	doman logrotate.8
	dodoc examples/logrotate*

	exeinto /etc/cron.daily
	doexe ${FILESDIR}/logrotate.cron

	insinto /etc
	doins ${FILESDIR}/logrotate.conf

	keepdir /etc/logrotate.d
}

pkg_postinst() {
	elog "If you wish to have logrotate e-mail you updates, please"
	elog "emerge virtual/mailx and configure logrotate in"
	elog "/etc/logrotate.conf appropriately"
	elog
	elog "Additionally, /etc/logrotate.conf may need to be modified"
	elog "for your particular needs.  See man logrotate for details."
}
