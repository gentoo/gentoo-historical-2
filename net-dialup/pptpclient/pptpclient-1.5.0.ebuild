# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/pptpclient/pptpclient-1.5.0.ebuild,v 1.3 2004/10/06 07:27:59 dragonheart Exp $

MY_P=pptp-linux-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Linux client for PPTP"
HOMEPAGE="http://pptpclient.sourceforge.net/"
SRC_URI="mirror://gentoo/pptp-command
	mirror://sourceforge/pptpclient/${MY_P}.tar.gz"
RESTRICT="nomirror"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64 ~alpha"
IUSE="tcltk"

DEPEND="net-dialup/ppp
	dev-lang/perl
	tcltk? ( dev-perl/perl-tk )"

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
	doins options.pptp
	dosbin ${DISTDIR}/pptp-command pptp_fe.pl
	use tcltk && dosbin xpptp_fe.pl
}
