# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/msmtp/msmtp-1.2.1.ebuild,v 1.7 2004/10/11 16:46:21 slarti Exp $

DESCRIPTION="An SMTP client and SMTP plugin for mail user agents such as Mutt"
HOMEPAGE="http://msmtp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
IUSE="ssl gnutls sasl"
DEPEND="virtual/libc
	ssl? (
		gnutls?	( >=net-libs/gnutls-1.0.0 )
		!gnutls?  ( >=dev-libs/openssl-0.9.6 )
	)
	sasl? ( virtual/gsasl )"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~x86 ~ppc"

src_compile () {
	local myconf

	use sasl \
		&& myconf="${myconf} --enable-gsasl" \
		|| myconf="${myconf} --disable-gsasl"

	if use ssl && use gnutls ; then
		myconf="${myconf} --enable-ssl --with-ssl=gnutls"
	elif use ssl && ! use gnutls ; then
		myconf="${myconf} --enable-ssl --with-ssl=openssl"
	else
		myconf="${myconf} --disable-ssl"
	fi

	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install () {
	einstall || die "install failed"

	dodoc AUTHORS ChangeLog NEWS README THANKS \
		doc/msmtprc.example doc/Mutt+msmtp.txt || die "dodoc failed"
}
