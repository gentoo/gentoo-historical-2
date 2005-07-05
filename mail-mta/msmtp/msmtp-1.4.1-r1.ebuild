# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/msmtp/msmtp-1.4.1-r1.ebuild,v 1.3 2005/07/05 20:51:39 slarti Exp $

inherit mailer

DESCRIPTION="An SMTP client and SMTP plugin for mail user agents such as Mutt"
HOMEPAGE="http://msmtp.sourceforge.net/"
SRC_URI="mirror://sourceforge/msmtp/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ssl gnutls sasl doc"
DEPEND="virtual/libc
	dev-util/pkgconfig
	ssl? (
		gnutls? ( >=net-libs/gnutls-1.2.0 )
		!gnutls? ( >=dev-libs/openssl-0.9.6 )
	)
	sasl? ( >=virtual/gsasl-0.2.4 )"

src_compile () {
	local myconf

	if use ssl && use gnutls ; then
		myconf="${myconf} --enable-ssl --with-ssl=gnutls"
	elif use ssl && ! use gnutls ; then
		myconf="${myconf} --enable-ssl --with-ssl=openssl"
	else
		myconf="${myconf} --disable-ssl"
	fi

	econf \
		$(use_enable sasl gsasl) \
		${myconf} \
		|| die "configure failed"

	emake || die "make failed"
}

src_install () {
	make DESTDIR=${D} install || die "install failed"

	if use mailwrapper ; then
		mailer_install_conf
	else
		dodir /usr/sbin
		dosym /usr/bin/msmtp /usr/sbin/sendmail || die "dosym failed"
	fi

	dodoc AUTHORS ChangeLog NEWS README* THANKS \
		doc/{Mutt+msmtp.txt,msmtprc*} || die "dodoc failed"

	if use doc ; then
		dohtml doc/msmtp.html || die "dohtml failed"
		dodoc doc/msmtp.pdf
	fi
}
