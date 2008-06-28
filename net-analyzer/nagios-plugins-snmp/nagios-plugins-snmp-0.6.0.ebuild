# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-plugins-snmp/nagios-plugins-snmp-0.6.0.ebuild,v 1.1 2008/06/28 09:48:18 dertobi123 Exp $

inherit eutils autotools

DESCRIPTION="Additional Nagios plugins for monitoring SNMP capable devices"
HOMEPAGE="http://nagios.manubulon.com"
SRC_URI="http://nagios.manubulon.com/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-analyzer/net-snmp"
RDEPEND="${DEPEND}"

S=${WORKDIR}/nagios-plugins-snmp

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	eautoreconf
}

src_compile() {
	econf \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--sysconfdir=/etc/nagios || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	chown -R root:nagios "${D}"/usr/$(get_libdir)/nagios/plugins || die "Failed Chown of ${D}usr/$(get_libdir)/nagios/plugins"
	chmod -R o-rwx "${D}"/usr/$(get_libdir)/nagios/plugins || "Failed Chmod of ${D}usr/$(get_libdir)/nagios/plugins"

	dodoc README NEWS AUTHORS
}
