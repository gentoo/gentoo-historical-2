# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/spamprobe/spamprobe-1.2.ebuild,v 1.1 2005/06/22 14:27:00 ticho Exp $

DESCRIPTION="Fast, intelligent, automatic spam detector using Paul Graham style Bayesian analysis of word counts in spam and non-spam emails."
HOMEPAGE="http://spamprobe.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="QPL"
SLOT="0"
KEYWORDS="~x86 ~ppc"

IUSE="berkdb"
DEPEND="berkdb? ( >=sys-libs/db-3.2 )
	sys-devel/autoconf"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dodoc README.txt ChangeLog LICENSE.txt
	make DESTDIR=${D} install || die

	insinto /usr/share/${PN}/contrib
	doins contrib/*
}
