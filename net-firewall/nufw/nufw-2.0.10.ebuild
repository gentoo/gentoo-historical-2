# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/nufw/nufw-2.0.10.ebuild,v 1.1 2006/11/13 22:36:25 cedk Exp $

inherit ssl-cert

DESCRIPTION="An enterprise grade authenticating firewall based on netfilter"
HOMEPAGE="http://www.nufw.org/"
SRC_URI="http://www.nufw.org/download/${PN}/${P}-1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug gdbm ident ldap mysql pam pam_nuauth pic postgres prelude \
unicode nfqueue nfconntrack static"

DEPEND=">=dev-libs/glib-2
	dev-libs/libgcrypt
	>=dev-libs/cyrus-sasl-2
	net-firewall/iptables
	>=net-libs/gnutls-1.1
	gdbm? ( sys-libs/gdbm )
	ident? ( net-libs/libident )
	ldap? ( >=net-nds/openldap-2 )
	mysql? ( dev-db/mysql )
	pam? ( sys-libs/pam )
	pam_nuauth? ( sys-libs/pam )
	postgres? ( dev-db/postgresql )
	nfqueue? ( net-libs/libnfnetlink
		net-libs/libnetfilter_queue )
	nfconntrack? ( net-libs/libnetfilter_conntrack )"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s/nuauth-key.pem/nuauth.key/" \
		-e "s/nuauth-cert.pem/nuauth.pem/" \
		conf/nuauth.conf || die "sed failed"
}

src_compile() {
	econf \
		$(use_enable static) \
		$(use_enable pam_nuauth pam-nuauth) \
		$(use_with pic) \
		$(use_with prelude prelude-log) \
		$(use_with mysql mysql-log) \
		$(use_with postgres pgsql-log) \
		$(use_with pam system-auth) \
		$(use_with ldap) \
		$(use_with gdbm) \
		$(use_with ident) \
		$(use_with nfqueue) \
		$(use_with nfconntrack) \
		$(use_with unicode utf8) \
		$(use_enable debug) \
		--sysconfdir="/etc/nufw" \
		--localstatedir="/var" \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}"/nufw-init.d nufw
	newconfd "${FILESDIR}"/nufw-conf.d nufw

	newinitd "${FILESDIR}"/nuauth-init.d nuauth
	newconfd "${FILESDIR}"/nuauth-conf.d nuauth

	insinto /etc/nufw
	doins conf/nuauth.conf
	docert nufw
	docert nuauth
	keepdir /var/run/nuauth

	dodoc AUTHORS ChangeLog NEWS README TODO
	docinto scripts
	dodoc scripts/*
	docinto conf
	dodoc conf/*.{nufw,schema,conf,dump,xml}
}
