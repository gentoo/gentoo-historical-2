# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/stunnel/stunnel-4.16.ebuild,v 1.2 2006/11/04 17:25:51 dertobi123 Exp $

inherit ssl-cert eutils flag-o-matic

DESCRIPTION="TLS/SSL - Port Wrapper"
HOMEPAGE="http://stunnel.mirt.net/"
SRC_URI="http://www.stunnel.org/download/stunnel/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="ipv6 selinux tcpd"

DEPEND="virtual/libc
	>=dev-libs/openssl-0.9.6j"
RDEPEND=">=dev-libs/openssl-0.9.6j
	selinux? ( sec-policy/selinux-stunnel )"

src_unpack() {
	unpack ${A}
	# Hack away generation of certificate
	sed -i s/^install-data-local:/do-not-run-this:/ "${S}"/tools/Makefile.in
}

src_compile() {
	local myconf=""
	# Don't shoot me for doing this! The stunnel configure script is broke and
	# doesn't honor --disable-foo
	if use ipv6 ; then
		myconf="${myconf} --enable-ipv6"
	fi
	if ! use tcpd ; then
		myconf="${myconf} --disable-libwrap"
	fi
	econf ${myconf} || die "econf died"
	emake || die "emake died"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	rm -rf ${D}/usr/share/doc/${PN}
	rm -f ${D}/{etc/stunnel/stunnel.conf-sample,usr/sbin/stunnel3}
	rm -f ${D}/usr/share/man/man8/{stunnel.fr.8,stunnel.pl.8}

	dodoc AUTHORS BUGS CREDITS INSTALL NEWS PORTS README TODO ChangeLog \
		doc/en/transproxy.txt
	dohtml doc/stunnel.html doc/en/VNC_StunnelHOWTO.html tools/ca.html \
		tools/importCA.html

	insinto /etc/stunnel
	donewins ${FILESDIR}/stunnel.conf stunnel.conf
	newinitd ${FILESDIR}/stunnel.rc6 stunnel
	# Check if there's currently an cert already there
	if [ ! -f /etc/stunnel/stunnel.key ]; then
		docert stunnel
	fi

	keepdir /var/run/stunnel
}

pkg_postinst() {
	enewgroup stunnel
	enewuser stunnel -1 -1 -1 stunnel

	chown stunnel:stunnel ${ROOT}/var/run/stunnel
	chown stunnel:stunnel ${ROOT}/etc/stunnel/stunnel.{conf,crt,csr,key,pem}
	chmod 0640 ${ROOT}/etc/stunnel/stunnel.{conf,crt,csr,key,pem}

	if [ ! -z "$(egrep '/etc/stunnel/stunnel.pid' \
		${ROOT}/etc/stunnel/stunnel.conf )" ] ; then

		ewarn "As of stunnel-4.09, the pid file will be located in /var/run/stunnel."
		ewarn "Please stop stunnel, etc-update, and start stunnel back up to ensure"
		ewarn "the update takes place"
		ewarn ""
		ewarn "The new location will be /var/run/stunnel/stunnel.pid"
		ebeep 3
		epause 3
	fi
}
