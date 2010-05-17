# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/acpid/acpid-2.0.4-r2.ebuild,v 1.3 2010/05/17 08:02:20 phajdan.jr Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="Daemon for Advanced Configuration and Power Interface"
HOMEPAGE="http://tedfelix.com/linux/acpid-netlink.html"
SRC_URI="http://tedfelix.com/linux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 -ppc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0.3.patch
}

src_compile() {
	tc-export CC CPP
	emake || die
	emake -C kacpimon || die
}

src_install() {
	emake DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" install || die

	dobin kacpimon/kacpimon || die
	newdoc kacpimon/README README.kacpimon

	exeinto /etc/acpi
	newexe "${FILESDIR}"/${PN}-1.0.6-default.sh default.sh || die
	insinto /etc/acpi/events
	newins "${FILESDIR}"/${PN}-1.0.4-default default || die

	newinitd "${FILESDIR}"/${PN}-2.0.3-init.d acpid || die
	newconfd "${FILESDIR}"/${PN}-1.0.6-conf.d acpid || die

	prepalldocs
}

pkg_postinst() {
	echo
	elog "You may wish to read the Gentoo Linux Power Management Guide,"
	elog "which can be found online at:"
	elog "http://www.gentoo.org/doc/en/power-management-guide.xml"
	echo
}
