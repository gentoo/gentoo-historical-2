# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/pptpclient/pptpclient-1.1.0-r1.ebuild,v 1.6 2003/09/07 00:09:22 msterret Exp $


S=${WORKDIR}/pptp-linux-${PV}-1
DESCRIPTION="Linux client for PPTP"
HOMEPAGE="http://pptpclient.sourceforge.net/"
SRC_URI="mirror://sourceforge/pptpclient/pptp-linux-${PV}-1.tar.gz"

DEPEND="net-dialup/ppp
		dev-lang/perl
		tcltk? ( dev-perl/perl-tk )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc amd64"
IUSE="tcltk"

src_compile() {
	cd ${S}
	tar zxf pptp-linux-${PV}.tar.gz
	cd ${S}/pptp-linux-${PV}

	make || die "make failed"
}

src_install() {
	cd ${S}
	insinto /etc/ppp
	doins options.pptp
	dosbin pptp-command pptp_fe.pl

	if [ -n "`use tcltk`" ] ; then
		sed s/pptp_fe/pptp_fe.pl/g < xpptp_fe.pl > xpptp_fe.pl.new
		mv xpptp_fe.pl.new xpptp_fe.pl
		dosbin xpptp_fe.pl
	fi

	cd pptp-linux-${PV}
	dosbin pptp

	dodoc AUTHORS COPYING ChangeLog DEVELOPERS NEWS README TODO USING
	dodoc Documentation/*
	dodoc Reference/*
}

