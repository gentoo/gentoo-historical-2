# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/spamprobe/spamprobe-0.9h.ebuild,v 1.2 2004/10/18 12:12:37 dholm Exp $

inherit eutils

DESCRIPTION="Fast, intelligent, automatic spam detector using Paul Graham style Bayesian analysis of word counts in spam and non-spam emails."
HOMEPAGE="http://spamprobe.sourceforge.net/"
SRC_URI="mirror://sourceforge/spamprobe/${P}.tar.gz
	http://dev.gentoo.org/~ticho/portage/spamprobe-0.9h-db4.patch.gz"

LICENSE="QPL"
SLOT="0"
KEYWORDS="~x86 ~ppc"

IUSE="berkdb"
DEPEND="berkdb? ( >=sys-libs/db-3.2 )
	sys-devel/autoconf"

src_compile() {
	unpack ${A}
	cd ${S}

	# patch for db4 detection and their respective versioned symbols
	epatch ${WORKDIR}/spamprobe-0.9h-db4.patch
	autoconf || die

	econf || die

	emake || die "compile problem"
}

src_install() {
	dodoc README.txt ChangeLog LICENSE.txt

	einstall || die
}
