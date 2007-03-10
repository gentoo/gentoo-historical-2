# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/perdition/perdition-1.17.ebuild,v 1.5 2007/03/10 14:26:51 vapier Exp $

inherit eutils

DESCRIPTION="modular and fully featured POP3 and IMAP4 proxy"
HOMEPAGE="http://www.vergenet.net/linux/perdition/"
SRC_URI="http://www.vergenet.net/linux/${PN}/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls pam ssl mysql odbc postgres gdbm ldap"

DEPEND="!mail-client/mailx
	!mail-client/nmh
	dev-scheme/guile
	>=dev-libs/vanessa-logger-0.0.6
	>=dev-libs/vanessa-adt-0.0.6
	>=net-libs/vanessa-socket-0.0.7
	ssl? ( dev-libs/openssl )
	odbc? ( dev-db/unixODBC )
	gdbm? ( sys-libs/gdbm )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	ldap? ( net-nds/openldap )
	pam? ( sys-libs/pam )
	nls? ( sys-devel/gettext )"

src_compile() {
	econf --disable-sendmail \
		$(use_enable nls) \
		$(use_enable pam) \
		$(use_enable ssl) \
		$(use_enable mysql) \
		$(use_enable odbc) \
		$(use_enable postgres) \
		$(use_enable gdbm) \
		$(use_enable ldap) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"

	dodoc README AUTHORS TODO

	newinitd "${FILESDIR}"/perdition.initd perdition
	newconfd "${FILESDIR}"/perdition.confd perdition

	keepdir /var/run/perdition
}

pkg_preinst() {
	enewuser perdition
	chown perdition "${D}"/var/run/perdition
}
