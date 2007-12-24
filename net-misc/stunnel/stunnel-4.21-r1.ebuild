# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/stunnel/stunnel-4.21-r1.ebuild,v 1.6 2007/12/24 15:34:28 armin76 Exp $

inherit autotools ssl-cert eutils

DESCRIPTION="TLS/SSL - Port Wrapper"
HOMEPAGE="http://stunnel.mirt.net/"
SRC_URI="http://www.stunnel.org/download/stunnel/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm hppa ~ia64 ppc ~ppc64 sparc x86"
IUSE="ipv6 selinux tcpd"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )
	>=dev-libs/openssl-0.9.6j"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-stunnel )"

pkg_setup() {
	enewgroup stunnel
	enewuser stunnel -1 -1 -1 stunnel
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-libwrap.patch"
	epatch "${FILESDIR}/${P}-setuid.patch"
	eautoreconf

	# Hack away generation of certificate
	sed -i -e "s/^install-data-local:/do-not-run-this:/" \
		tools/Makefile.in || die "sed failed"
}

src_compile() {
	econf $(use_enable ipv6) \
		$(use_enable tcpd libwrap) || die "econf died"
	emake || die "emake died"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -rf "${D}"/usr/share/doc/${PN}
	rm -f "${D}"/etc/stunnel/stunnel.conf-sample "${D}"/usr/bin/stunnel3 \
		"${D}"/usr/share/man/man8/stunnel.{fr,pl}.8

	# The binary was moved to /usr/bin with 4.21,
	# symlink for backwards compatibility
	dosym ../bin/stunnel /usr/sbin/stunnel

	dodoc AUTHORS BUGS CREDITS PORTS README TODO ChangeLog doc/en/transproxy.txt
	dohtml doc/stunnel.html doc/en/VNC_StunnelHOWTO.html tools/ca.html \
		tools/importCA.html

	insinto /etc/stunnel
	doins "${FILESDIR}"/stunnel.conf
	newinitd "${FILESDIR}"/stunnel.rc6 stunnel

	keepdir /var/run/stunnel
	fowners stunnel:stunnel /var/run/stunnel
}

pkg_postinst() {
	if [ ! -f "${ROOT}"/etc/stunnel/stunnel.key ]; then
		install_cert /etc/stunnel/stunnel
		chown stunnel:stunnel "${ROOT}"/etc/stunnel/stunnel.{crt,csr,key,pem}
		chmod 0640 "${ROOT}"/etc/stunnel/stunnel.{crt,csr,key,pem}
	fi

	if [ ! -z "$(grep /etc/stunnel/stunnel.pid \
		"${ROOT}"/etc/stunnel/stunnel.conf )" ] ; then

		ewarn "As of stunnel-4.09, the pid file will be located in /var/run/stunnel."
		ewarn "Please stop stunnel, etc-update, and start stunnel back up to ensure"
		ewarn "the update takes place"
		ewarn
		ewarn "The new location will be /var/run/stunnel/stunnel.pid"
	fi
}
