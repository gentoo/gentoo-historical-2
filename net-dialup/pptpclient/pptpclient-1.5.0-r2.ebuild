# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/pptpclient/pptpclient-1.5.0-r2.ebuild,v 1.3 2005/09/10 03:33:33 tgall Exp $

MY_P=pptp-linux-${PV}
MY_CMD=pptp-command-20050401

DESCRIPTION="Linux client for PPTP"
HOMEPAGE="http://pptpclient.sourceforge.net/"
SRC_URI="mirror://sourceforge/pptpclient/${MY_P}.tar.gz
	mirror://gentoo/${MY_CMD}.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64 ~alpha ppc64"
IUSE="tcltk"

DEPEND=">=net-dialup/ppp-2.4.2
	dev-lang/perl
	tcltk? ( dev-perl/perl-tk )"

S=${WORKDIR}/${MY_P}

src_compile() {
	emake OPTIMISE= DEBUG= CFLAGS="${CFLAGS}" || die "make failed"
}

src_install() {
	dosbin pptp
	dodoc AUTHORS COPYING ChangeLog DEVELOPERS NEWS README TODO USING
	dodoc Documentation/*
	dodoc Reference/*
	dodir /etc/pptp.d

	# The current version of pptp-linux doesn't include the
	# RH-specific portions, so include them ourselves.
	cd ${FILESDIR}
	insinto /etc/ppp
	doins new-mppe/options.pptp
	newsbin ${WORKDIR}/${MY_CMD} pptp-command
	dosbin pptp_fe.pl
	use tcltk && dosbin xpptp_fe.pl
}
