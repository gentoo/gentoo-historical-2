# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/pymsn-t/pymsn-t-0.11.2.ebuild,v 1.1 2007/04/28 23:21:46 griffon26 Exp $

NEED_PYTHON=2.3

inherit eutils multilib python

MY_PN="pymsnt"
S=${WORKDIR}/${MY_PN}-${PV}
DESCRIPTION="Python based jabber transport for MSN"
HOMEPAGE="http://msn-transport.jabberstudio.org/"
SRC_URI="http://msn-transport.jabberstudio.org/tarballs/${MY_PN}-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

DEPEND="net-im/jabber-base"
RDEPEND="${DEPEND}
	>=dev-python/twisted-2.2.0
	>=dev-python/twisted-words-0.1.0
	>=dev-python/twisted-web-0.5.0
	>=dev-python/imaging-1.1"

src_unpack() {
	unpack ${A} && cd "${S}" || die "unpack failed"
	find -name ".svn" -type d -exec rm -rf {} \; &> /dev/null
	epatch "${FILESDIR}/${P}-twisted-2.5.patch"
}

src_install() {
	local inspath

	python_version
	inspath=/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
	insinto ${inspath}
	doins -r data src
	newins PyMSNt.py ${PN}.py

	insinto /etc/jabber
	newins config-example.xml ${PN}.xml
	fperms 600 /etc/jabber/${PN}.xml
	fowners jabber:jabber /etc/jabber/${PN}.xml
	dosed \
		"s:<!-- <spooldir>[^\<]*</spooldir> -->:<spooldir>/var/spool/jabber</spooldir>:" \
		/etc/jabber/${PN}.xml
	dosed \
		"s:<pid>[^\<]*</pid>:<pid>/var/run/jabber/${PN}.pid</pid>:" \
		/etc/jabber/${PN}.xml
	dosed \
		"s:<host>[^\<]*</host>:<host>example.org</host>:" \
		/etc/jabber/${PN}.xml
	dosed \
		"s:<jid>[^\<]*</jid>:<jid>msn.example.org</jid>:" \
		/etc/jabber/${PN}.xml

	newinitd "${FILESDIR}/${PN}-0.11.2-initd" ${PN}
	dosed "s:INSPATH:${inspath}:" /etc/init.d/${PN}
}

pkg_postinst() {
	python_version
	python_mod_optimize ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}

	elog "A sample configuration file has been installed in /etc/jabber/${PN}.xml."
	elog "Please edit it and the configuration of your Jabber server to match."
}

pkg_postrm() {
	python_version
	python_mod_cleanup ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
}
