# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/freeipmi/freeipmi-0.6.10.ebuild,v 1.2 2009/05/03 17:17:10 maekke Exp $

WANT_AUTOMAKE=1.9

inherit autotools

DESCRIPTION="Provides Remote-Console and System Management Software as per IPMI v1.5/2.0"
HOMEPAGE="http://www.gnu.org/software/freeipmi/"
SRC_URI="ftp://ftp.zresearch.com/pub/${PN}/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug syslog"

RDEPEND="dev-libs/libgcrypt"
DEPEND="${RDEPEND}
		virtual/os-headers"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}+glibc-2.8.patch"
	AT_M4DIR="config" eautomake
}

src_compile() {
	econf \
		--disable-init-scripts \
		$(use_enable debug) \
		--enable-logrotate-config \
		$(use_enable syslog) \
		--localstatedir=/var \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog* DISCLAIMER* NEWS README* TODO
	dodoc doc/*.txt

	rm /usr/share/doc/${PF}/COPYING* /usr/share/doc/${PF}/INSTALL

	keepdir \
		/var/cache/ipmimonitoringsdrcache \
		/var/lib/freeipmi \
		/var/log/{freeipmi,ipmiconsole}

	newinitd "${FILESDIR}/ipmidetectd.initd" ipmidetectd
	newinitd "${FILESDIR}/bmc-watchdog.initd" bmc-watchdog
	newconfd "${FILESDIR}/bmc-watchdog.confd" bmc-watchdog
}
