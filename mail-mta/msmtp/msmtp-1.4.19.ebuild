# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/msmtp/msmtp-1.4.19.ebuild,v 1.1 2010/04/02 16:17:12 a3li Exp $

EAPI=2

DESCRIPTION="An SMTP client and SMTP plugin for mail user agents such as Mutt"
HOMEPAGE="http://msmtp.sourceforge.net/"
SRC_URI="mirror://sourceforge/msmtp/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc gnome-keyring gnutls idn mailwrapper nls sasl ssl"

DEPEND="idn? ( net-dns/libidn )
	nls? ( virtual/libintl )
	gnome-keyring? ( gnome-base/gnome-keyring )
	gnutls? ( >=net-libs/gnutls-1.2.0 )
	!gnutls? ( ssl? ( >=dev-libs/openssl-0.9.6 ) )
	sasl? ( >=virtual/gsasl-0.2.4 )"

RDEPEND="${DEPEND}
	!mailwrapper? ( !virtual/mta )
	mailwrapper? ( >=net-mail/mailwrapper-0.2 )"

DEPEND="${DEPEND}
	nls? ( sys-devel/gettext )
	dev-util/pkgconfig"

PROVIDE="virtual/mta"

src_configure () {
	local myconf

	if use gnutls ; then
		myconf="--with-ssl=gnutls"
	elif use ssl ; then
		myconf="--with-ssl=openssl"
	else
		myconf="--with-ssl=no"
	fi

	econf \
		$(use_with idn libidn) \
		$(use_with sasl libgsasl) \
		$(use_with gnome-keyring ) \
		$(use_enable nls) \
		${myconf}
}

src_install () {
	emake DESTDIR="${D}" install || die "install failed"

	if use mailwrapper ; then
		insinto /etc/mail
		doins "${FILESDIR}"/mailer.conf
	else
		dodir /usr/sbin
		dosym /usr/bin/msmtp /usr/sbin/sendmail || die "dosym failed"
	fi

	dodoc AUTHORS ChangeLog NEWS README THANKS \
		doc/{Mutt+msmtp.txt,msmtprc*} || die "dodoc failed"

	if use doc ; then
		dohtml doc/msmtp.html || die "dohtml failed"
		dodoc doc/msmtp.pdf
	fi

	local msmtpqueuedir=/usr/share/${PN}/msmtpqueue
	insinto ${msmtpqueuedir}
	exeinto ${msmtpqueuedir}
	doins scripts/msmtpqueue/{ChangeLog,README} || die "dodoc scripts/msmtpqueue failed"
	doexe scripts/msmtpqueue/*.sh || die "doexe failed"
}
